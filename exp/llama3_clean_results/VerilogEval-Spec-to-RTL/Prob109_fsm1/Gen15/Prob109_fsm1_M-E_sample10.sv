module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states
parameter A = 1'b0, B = 1'b1;

reg state; // 1-bit register to hold the state
assign out = state; // assign output as the current state

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= B; // asynchronous reset to state B
    end else begin
        case (state)
            A: state <= in? A : B; // Stay in A on in=1, go to B on in=0
            B: state <= in? B : A; // Stay in B on in=1, go to A on in=0
            default: state <= B; // Default to state B
        endcase
    end
end

endmodule