module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

reg [1:0] state; // State variable, B=0, A=1
parameter B = 0, A = 1; // Define states for clarity

always @(posedge clk) begin
    if (reset) begin // Active high synchronous reset
        state <= B;
    end else begin
        case (state)
            B: if (~in) state <= A; // Transition to A if in is 0
                 else state <= B; // Stay in B if in is 1
            A: if (~in) state <= B; // Transition to B if in is 0
                 else state <= A; // Stay in A if in is 1
            default: state <= B; // Default to B in case of unexpected state
        endcase
    end
end

always @(*) begin
    case (state)
        B: out = 1'b1; // Output 1 when in state B
        A: out = 1'b0; // Output 0 when in state A
        default: out = 1'b0; // Default output if in an unexpected state
    endcase
end

endmodule