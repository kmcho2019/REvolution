module TopModule (
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_taken,
    input [31:0] train_history,
    output [31:0] predict_history
);

    // Dual history registers
    reg [31:0] safe_history;  // Committed state
    reg [31:0] spec_history;  // Speculative state
    reg spec_valid;           // Track if spec_history is ahead

    // Output is always the speculative state
    assign predict_history = spec_history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            safe_history <= 32'b0;
            spec_history <= 32'b0;
            spec_valid <= 1'b0;
        end else begin
            // Priority 1: Handle mispredictions (rollback)
            if (train_mispredicted) begin
                spec_history <= {train_history[30:0], train_taken};
                safe_history <= {train_history[30:0], train_taken};
                spec_valid <= 1'b0;
            end
            // Priority 2: Handle new predictions
            else if (predict_valid) begin
                spec_history <= {spec_history[30:0], predict_taken};
                spec_valid <= 1'b1;
            end
            // Priority 3: Synchronize when idle
            else if (spec_valid) begin
                safe_history <= spec_history;
                spec_valid <= 1'b0;
            end
        end
    end

    // Assertion for verification (optional)
    // synthesis translate_off
    always @(posedge clk) begin
        if (train_mispredicted && predict_valid) begin
            $display("Warning: Misprediction and prediction simultaneous");
        end
    end
    // synthesis translate_on

endmodule