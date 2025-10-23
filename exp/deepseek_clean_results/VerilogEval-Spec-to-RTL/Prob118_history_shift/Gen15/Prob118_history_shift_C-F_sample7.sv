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

    // Dual history registers with explicit enable signals
    reg [31:0] safe_history;  // Committed state
    reg [31:0] spec_history;  // Speculative state
    
    // Update conditions
    wire safe_en = areset || train_mispredicted;
    wire spec_en = areset || train_mispredicted || predict_valid;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            safe_history <= 32'b0;
        end else if (safe_en) begin
            // Only update on misprediction
            safe_history <= {train_history[30:0], train_taken};
        end
    end
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            spec_history <= 32'b0;
        end else if (spec_en) begin
            if (train_mispredicted) begin
                // Sync with safe history
                spec_history <= {train_history[30:0], train_taken};
            end else begin
                // Shift in prediction
                spec_history <= {spec_history[30:0], predict_taken};
            end
        end
    end

    // Output follows speculative state
    assign predict_history = spec_history;

endmodule