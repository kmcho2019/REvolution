module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State definitions
    localparam STATE_B = 1'b0;
    localparam STATE_A = 1'b1;
    
    reg state;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_B;  // Synchronous reset to state B
        end else begin
            state <= state ? in : ~in;  // Compact XOR-like transition
        end
    end

    // Output logic (Moore style)
    assign out = ~state;  // Directly derived from state

endmodule