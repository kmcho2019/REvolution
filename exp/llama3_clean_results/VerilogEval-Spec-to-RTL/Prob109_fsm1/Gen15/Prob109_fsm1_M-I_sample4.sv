module TopModule(
    input           clk,
    input           areset,
    input           in,
    output          out
);

reg state; // 1 represents state B, 0 represents state A

// Sequential logic to update current state, ensuring asynchronous reset
always @(posedge clk or posedge areset)
begin
    if (areset) 
        state <= 1'b1; // Asynchronously reset to state B
    else 
        case(state)
            1'b1: state <= in; // If in state B and in=1, stay in B; if in=0, move to A
            1'b0: state <= ~in; // If in state A and in=0, move to B; if in=1, stay in A
        endcase
end

// Output logic (Moore machine, output based on current state)
assign out = state;

endmodule