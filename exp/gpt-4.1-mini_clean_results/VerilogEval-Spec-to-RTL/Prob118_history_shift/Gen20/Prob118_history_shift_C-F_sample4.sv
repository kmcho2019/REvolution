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

    // Enable updating only when misprediction or prediction valid occurs
    wire update_en = train_mispredicted || predict_valid;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else if (train_mispredicted) begin
            predict_history <= {train_history[30:0], train_taken};
        end else if (predict_valid) begin
            predict_history <= {predict_history[30:0], predict_taken};
        end else begin
            // Hold current state (no assignment needed since non-blocking)
            // but explicitly showing for clarity and synthesis tools
            predict_history <= predict_history;
        end
    end

endmodule