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

    reg [31:0] current_history, next_history;

    // Combinational logic to generate next_history based on inputs
    always @(*) begin
        if (train_mispredicted)
            next_history = {train_history[30:0], train_taken};
        else if (predict_valid)
            next_history = {current_history[30:0], predict_taken};
        else
            next_history = current_history;
    end

    // Sequential update of current_history with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_history <= 32'b0;
        else
            current_history <= next_history;
    end

    assign predict_history = current_history;

endmodule