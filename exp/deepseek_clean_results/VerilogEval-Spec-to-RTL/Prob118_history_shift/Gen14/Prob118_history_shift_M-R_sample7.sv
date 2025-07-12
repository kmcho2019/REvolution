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

    // Register declarations
    reg [31:0] safe_history;  // Committed state
    reg [31:0] spec_history;  // Speculative state

    // Next-state logic (combinational)
    wire [31:0] next_safe_history = train_mispredicted ? {train_history, train_taken} : safe_history;
    wire [31:0] next_spec_history = train_mispredicted ? {train_history, train_taken} :
                                  predict_valid ? {spec_history[30:0], predict_taken} :
                                  spec_history;

    // Sequential updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            safe_history <= 32'b0;
            spec_history <= 32'b0;
        end else begin
            safe_history <= next_safe_history;
            spec_history <= next_spec_history;
        end
    end

    // Output assignment
    assign predict_history = spec_history;

endmodule