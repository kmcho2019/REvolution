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

    // Compute next history value combinationally
    always @(*) begin
        if (train_mispredicted) begin
            // Misprediction takes precedence
            next_history = {train_history[30:0], train_taken};
        end else if (predict_valid) begin
            // Shift left and insert predict_taken at LSB
            next_history = {history[30:0], predict_taken};
        end else begin
            // Hold current history
            next_history = history;
        end
    end

    // Register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history <= 32'b0;
        end else begin
            history <= next_history;
        end
    end

    assign predict_history = history;

endmodule