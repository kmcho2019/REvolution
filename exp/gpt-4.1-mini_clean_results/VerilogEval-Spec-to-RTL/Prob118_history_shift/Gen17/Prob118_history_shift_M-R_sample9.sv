module TopModule (
    input          clk,
    input          areset,
    input          predict_valid,
    input          predict_taken,
    input          train_mispredicted,
    input          train_taken,
    input  [31:0]  train_history,
    output [31:0]  predict_history
);

    reg [31:0] history;
    reg [31:0] next_history;

    // Combinational logic to compute next history value
    always @(*) begin
        if (train_mispredicted)
            // Roll back: load corrected history plus actual branch result
            next_history = {train_history[30:0], train_taken};
        else if (predict_valid)
            // Shift in prediction taken bit
            next_history = {history[30:0], predict_taken};
        else
            // No update
            next_history = history;
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            history <= 32'b0;
        else
            history <= next_history;
    end

    assign predict_history = history;

endmodule