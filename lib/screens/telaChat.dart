import 'dart:math';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<String> messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<List<String>> savedChats = [];
  String? userName;

  final List<String> botResponses = [
    "Olá! Como posso ajudá-lo?",
    "Espero que você esteja tendo um ótimo dia!",
    "Interessante... Continue.",
    "Desculpe, eu não entendi isso.",
    "Claro, eu posso fazer isso!"
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showNameInputDialog();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showNameInputDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final TextEditingController nameController = TextEditingController();
        return AlertDialog(
          title: const Text("Insira seu nome"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Nome"),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("Confirmar"),
              onPressed: () {
                setState(() {
                  userName = nameController.text;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleSubmitted(String text) {
    if (userName == null || userName!.isEmpty) {
      _showNameInputDialog();
      return;
    }

    _controller.clear();
    setState(() {
      messages.add("$userName: $text");
      String botResponse = botResponses[Random().nextInt(botResponses.length)];
      messages.add("Bot: $botResponse");
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showSaveChatDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Salvar Conversa"),
          content: const Text("Você deseja salvar esta conversa?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Não"),
              onPressed: () {
                setState(() {
                  messages.clear();
                });
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text("Sim"),
              onPressed: () {
                setState(() {
                  savedChats.add(List.from(messages));
                  messages.clear();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _recoverChat(List<String> chat) {
    setState(() {
      messages.clear();
      messages.addAll(chat);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chatbot Flutter"),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _showSaveChatDialog,
          ),
        ],
      ),
      body: Row(
        children: [
          Container(
            width: 200,
            color: Colors.grey[200],
            child: ListView.builder(
              itemCount: savedChats.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Conversa ${index + 1}'),
                  onTap: () => _recoverChat(savedChats[index]),
                );
              },
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 20.0),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      bool isUserMessage =
                          messages[index].startsWith("$userName:");
                      return Align(
                        alignment: isUserMessage
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: isUserMessage
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              isUserMessage ? userName! : "Bot",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              margin: const EdgeInsets.symmetric(vertical: 2.0),
                              decoration: BoxDecoration(
                                color: isUserMessage
                                    ? Colors.blue[100]
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text(messages[index]),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          onSubmitted: _handleSubmitted,
                          decoration: const InputDecoration(
                            hintText: "Digite sua mensagem...",
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () => _handleSubmitted(_controller.text),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
