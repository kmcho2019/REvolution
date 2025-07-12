module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // Using a single-bit register to represent the state (0 for B, 1 for A)

always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset state is B, represented by binary '0'
    end else begin
        case(state)
            0: state <= ~in; // From B, go to A if in=0, stay in B if in=1
            1: state <= in;  // From A, go to B if in=0, stay in A if in=1
        endcase
    end
end

always @(posedge clk) begin
    if(reset) begin
        out <= 1; // Reset output is 1 (corresponding to state B)
    end else begin
        out <= ~state; // Output is 1 in state B (0) and 0 in state A (1)
    end
end

endmodule