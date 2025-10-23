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
    reg [4:0] speculative_depth; // Up to 32 speculative bits
    reg speculative_bit;
    wire [4:0] next_depth;

    assign next_depth = speculative_depth + 1'b1;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            committed_history <= 32'b0;
            speculative_depth <= 5'b0;
            speculative_bit <= 1'b0;
        end else if (train_mispredicted) begin
            // Rollback: reconstruct history from train_history + actual taken
            committed_history <= {train_history[30:0], train_taken};
            speculative_depth <= 5'b0;
        end else if (predict_valid) begin
            if (speculative_depth == 5'd31) begin
                // Shift out oldest bit when full
                committed_history <= {committed_history[30:0], speculative_bit};
                speculative_bit <= predict_taken;
            end else begin
                // Track new speculative bit
                speculative_bit <= predict_taken;
                speculative_depth <= next_depth;
            end
        end else if (speculative_depth > 0) begin
            // Commit speculative bits when no new prediction
            committed_history <= {committed_history[30:0], speculative_bit};
            speculative_depth <= speculative_depth - 1'b1;
        end
    end

    // Output combines committed history with speculative bits
    assign predict_history = (speculative_depth > 0) ?
                           {committed_history[31-speculative_depth:0], 
                           {speculative_depth{speculative_bit}}} :
                           committed_history;

endmodule