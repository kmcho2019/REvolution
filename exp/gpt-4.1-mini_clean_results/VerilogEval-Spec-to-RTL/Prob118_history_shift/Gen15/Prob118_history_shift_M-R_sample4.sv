module TopModule(
    input         clk,
    input         areset,
    input         predict_valid,
    input         predict_taken,
    input         train_mispredicted,
    input         train_taken,
    input  [31:0] train_history,
    output [31:0] predict_history
);

    reg [31:0] history_reg;
    reg [31:0] history_next;

    // Combinational logic for next state of history
    always @(*) begin
        if (train_mispredicted)
            history_next = {train_history[30:0], train_taken};
        else if (predict_valid)
            history_next = {history_reg[30:0], predict_taken};
        else
            history_next = history_reg;
    end

    // Asynchronous reset and synchronous update
    always @(posedge clk or posedge areset) begin
        if (areset)
            history_reg <= 32'b0;
        else
            history_reg <= history_next;
    end

    assign predict_history = history_reg;

endmodule