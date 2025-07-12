module TopModule (
    input         clk,
    input         areset,
    input         predict_valid,
    input         predict_taken,
    input         train_mispredicted,
    input         train_taken,
    input  [31:0] train_history,
    output reg [31:0] predict_history
);

    reg [31:0] next_state;

    // Combinational logic to compute next_state with priority:
    // rollback (train_mispredicted) > prediction (predict_valid) > hold current state
    always @* begin
        if (train_mispredicted) begin
            // Rollback: load train_history concatenated with train_taken
            next_state = {train_history[30:0], train_taken};
        end else if (predict_valid) begin
            // Prediction: shift in predict_taken from LSB
            next_state = {predict_history[30:0], predict_taken};
        end else begin
            // Hold current state
            next_state = predict_history;
        end
    end

    // Sequential logic with asynchronous positive-edge reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else begin
            predict_history <= next_state;
        end
    end

endmodule