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
    reg speculative_bit;
    reg [5:0] speculative_depth; // Enough for up to 64 speculative branches

    wire [31:0] speculative_history = 
        (speculative_depth > 0) ? 
        {committed_history[30:0], speculative_bit} : 
        committed_history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            committed_history <= 32'b0;
            speculative_bit <= 1'b0;
            speculative_depth <= 6'b0;
        end else if (train_mispredicted) begin
            // Rollback: load committed history from train info
            committed_history <= {train_history[30:0], train_taken};
            speculative_bit <= 1'b0;
            speculative_depth <= 6'b0;
        end else begin
            if (predict_valid) begin
                // Record new speculative prediction
                speculative_bit <= predict_taken;
                speculative_depth <= speculative_depth + 1;
            end
            
            // Apply pending speculative updates when no new activity
            if (!predict_valid && !train_mispredicted && speculative_depth > 0) begin
                committed_history <= {committed_history[30:0], speculative_bit};
                speculative_depth <= speculative_depth - 1;
            end
        end
    end

    assign predict_history = speculative_history;

endmodule