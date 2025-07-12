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

    reg [31:0] safe_history;  // Committed state
    reg [31:0] spec_history;  // Speculative state
    wire [31:0] next_safe_history;
    wire [31:0] next_spec_history;

    // Safe history only updates on misprediction or reset
    assign next_safe_history = train_mispredicted ? {train_history[30:0], train_taken} : safe_history;

    // Speculative history updates on predictions or gets corrected on misprediction
    assign next_spec_history = train_mispredicted ? next_safe_history : 
                             predict_valid ? {spec_history[30:0], predict_taken} : 
                             spec_history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            safe_history <= 32'b0;
            spec_history <= 32'b0;
        end else begin
            safe_history <= next_safe_history;
            spec_history <= next_spec_history;
        end
    end

    // Output comes from speculative state unless we're in misprediction
    assign predict_history = train_mispredicted ? next_safe_history : spec_history;

endmodule