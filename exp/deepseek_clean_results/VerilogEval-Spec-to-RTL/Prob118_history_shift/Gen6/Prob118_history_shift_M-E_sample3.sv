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

    // Two history registers
    reg [31:0] speculative_history;
    reg [31:0] committed_history;
    
    // Next state signals
    wire [31:0] next_speculative;
    wire [31:0] next_committed;
    
    // Speculative update (shift in prediction)
    assign next_speculative = {speculative_history[30:0], predict_taken};
    
    // Committed update (misprediction recovery)
    assign next_committed = {train_history[30:0], train_taken};
    
    // Output selection (speculative during normal operation)
    assign predict_history = speculative_history;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            speculative_history <= 32'b0;
            committed_history <= 32'b0;
        end
        else begin
            // Handle misprediction first (highest priority)
            if (train_mispredicted) begin
                speculative_history <= next_committed;
                committed_history <= next_committed;
            end
            // Normal prediction path
            else if (predict_valid) begin
                speculative_history <= next_speculative;
            end
            // Default case maintains current state
        end
    end

endmodule