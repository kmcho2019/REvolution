module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // 1-bit variable to hold the state (A=0, B=1)

// Sequential logic: Update state
always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 1'b1; // Reset to state B
    end else begin
        case(state)
            1'b0: state <= in ? 1'b0 : 1'b1; // From A, stay if in=1, go to B if in=0
            1'b1: state <= in ? 1'b1 : 1'b0; // From B, stay if in=1, go to A if in=0
            default: state <= 1'bx; 
        endcase
    end
end

// Combinational logic: Determine output
assign out = state; // Since out = 1 when state is B (1'b1) and out = 0 when state is A (1'b0)

endmodule