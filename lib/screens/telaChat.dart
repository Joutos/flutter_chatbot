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
  String? userName;

  final List<String> botResponses = [
    "Olá! Como posso ajudá-lo?",
    "Espero que você esteja tendo um ótimo dia!",
    "Interessante... Continue.",
    "Desculpe, eu não entendi isso.",
    "Claro, eu posso fazer isso!",
    "Poderia elaborar mais sobre isso?",
    "Entendi. O que mais você gostaria de saber?",
    "Isso soa fascinante!",
    "Vou precisar de mais informações para ajudá-lo.",
    "Obrigado por compartilhar isso comigo.",
    "Que legal! Conte-me mais.",
    "Posso ajudar com mais alguma coisa?",
    "Isso é algo sobre o qual vale a pena pensar.",
    "Como você chegou a essa conclusão?",
    "Você tem algum exemplo para ilustrar?",
    "Essa é uma ótima pergunta!",
    "Isso é um ponto interessante.",
    "Como posso ser mais útil?",
    "Estou aqui para ajudar!",
    "Vamos resolver isso juntos.",
    "Pode me dar mais detalhes?",
    "O que você acha disso?",
    "Vamos em frente.",
    "Estou aqui para ouvir.",
    "Vamos descobrir isso juntos.",
    "Isso é muito útil, obrigado.",
    "Como posso tornar isso mais claro para você?",
    "Qual é o próximo passo?",
    "Vamos tentar outra abordagem.",
    "Posso te ajudar com mais alguma coisa?",
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
      barrierDismissible: false, // Não permite fechar o modal tocando fora dele
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chatbot Flutter"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                bool isUserMessage = messages[index].startsWith("$userName:");
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
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
    );
  }
}
