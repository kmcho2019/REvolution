module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg state; // 1-bit signal to represent the state
always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 0; // Reset state is B
    end else begin
        case(state)
            0: state <= ~in; // State B, go to A if in=0, stay in B if in=1
            1: state <= in;  // State A, stay in A if in=1, go to B if in=0
        endcase
    end
end

assign out = ~state; // Output is 1 when in state B (state=0), 0 when in state A (state=1)

endmodule