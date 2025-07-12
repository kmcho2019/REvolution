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

    reg [31:0] history;
    reg [31:0] next_history;

    // Combinational logic to determine next history value
    always @(*) begin
        if (train_mispredicted)
            next_history = {train_history[30:0], train_taken};
        else if (predict_valid)
            next_history = {history[30:0], predict_taken};
        else
            next_history = history;
    end

    // Sequential logic: update history register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            history <= 32'b0;
        else
            history <= next_history;
    end

    assign predict_history = history;

endmodule