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

    reg [31:0] safe_history;  // Committed history
    reg [31:0] spec_history;  // Speculative history

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            safe_history <= 32'b0;
            spec_history <= 32'b0;
        end else begin
            // Update safe history only on misprediction
            if (train_mispredicted) begin
                safe_history <= {train_history[30:0], train_taken};
                spec_history <= {train_history[30:0], train_taken};
            end
            // Always update speculative history with predictions
            else if (predict_valid) begin
                spec_history <= {spec_history[30:0], predict_taken};
            end
        end
    end

    // Output tracks speculative state for predictions
    assign predict_history = (predict_valid && !train_mispredicted) ? 
                           {spec_history[30:0], predict_taken} : 
                           safe_history;

endmodule