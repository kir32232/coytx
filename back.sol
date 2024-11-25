// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ReturnBNB {
    // Событие для логирования входящих платежей
    event Received(address indexed sender, uint256 amount);
    // Событие для логирования возврата BNB
    event SentBack(address indexed receiver, uint256 amount);

    // Функция, которая срабатывает при получении BNB
    receive() external payable {
        // Логируем полученный платеж
        emit Received(msg.sender, msg.value);

        // Возвращаем BNB отправителю
        (bool success, ) = msg.sender.call{value: msg.value}("");
        require(success, "Failed to send BNB back");

        // Логируем успешный возврат
        emit SentBack(msg.sender, msg.value);
    }

    // Функция для вывода остатка BNB из контракта (только владелец)
    function withdraw() external {
        require(address(this).balance > 0, "No BNB to withdraw");
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Withdraw failed");
    }
}
