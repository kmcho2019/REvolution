module TopModule (
    input          clk,
    input          areset,
    input          predict_valid,
    input          predict_taken,
    input          train_mispredicted,
    input          train_taken,
    input  [31:0]  train_history,
    output reg [31:0] predict_history
);

    reg [31:0] next_history;

    // Combinational logic to determine next_history with misprediction priority
    always @(*) begin
        if (train_mispredicted) begin
            // Load history before mispredicted branch concatenated with actual taken bit
            next_history = {train_history, 1'b0} | 32'b0; // prepare 33-bit vector truncated to 32 bits by concatenation below
            next_history = {train_history[30:0], train_taken};
        end else if (predict_valid) begin
            // Shift left by 1 and insert predict_taken at LSB
            next_history = {predict_history[30:0], predict_taken};
        end else begin
            // Hold current history
            next_history = predict_history;
        end
    end

    // Sequential update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else begin
            predict_history <= next_history;
        end
    end

endmodule