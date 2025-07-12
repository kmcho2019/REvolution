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

    reg [31:0] committed_history;
    reg [31:0] spec_history;
    reg spec_valid;

    // Output the speculative history if valid, else committed
    assign predict_history = spec_valid ? spec_history : committed_history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            committed_history <= 32'b0;
            spec_history <= 32'b0;
            spec_valid <= 1'b0;
        end else begin
            // Handle misprediction (highest priority)
            if (train_mispredicted) begin
                committed_history <= {train_history[30:0], train_taken};
                spec_history <= {train_history[30:0], train_taken};
                spec_valid <= 1'b0;
            end
            // Handle new prediction
            else if (predict_valid) begin
                spec_history <= {committed_history[30:0], predict_taken};
                spec_valid <= 1'b1;
            end
            // Commit speculative state if no misprediction
            else if (spec_valid) begin
                committed_history <= spec_history;
                spec_valid <= 1'b0;
            end
        end
    end

endmodule