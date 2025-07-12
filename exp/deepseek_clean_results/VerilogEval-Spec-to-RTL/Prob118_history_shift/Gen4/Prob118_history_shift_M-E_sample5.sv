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
        end else if (train_mispredicted) begin
            // Rollback: use train_history + actual outcome
            safe_history <= {train_history[30:0], train_taken};
            spec_history <= {train_history[30:0], train_taken};
        end else begin
            if (predict_valid) begin
                // Speculative update
                spec_history <= {spec_history[30:0], predict_taken};
            end
            // Commit speculative state if no misprediction
            safe_history <= spec_history;
        end
    end

    // Output always shows speculative state
    assign predict_history = (predict_valid && !train_mispredicted) ? 
                           {spec_history[30:0], predict_taken} : 
                           spec_history;

endmodule