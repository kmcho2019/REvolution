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
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            safe_history <= 32'b0;
            spec_history <= 32'b0;
        end else begin
            // Committed updates (mispredictions only)
            if (train_mispredicted) begin
                safe_history <= {train_history, train_taken};
                spec_history <= {train_history, train_taken};
            end
            // Speculative updates (predictions)
            else if (predict_valid) begin
                spec_history <= {spec_history[30:0], predict_taken};
            end
        end
    end

    // Output follows speculative state
    assign predict_history = spec_history;

endmodule