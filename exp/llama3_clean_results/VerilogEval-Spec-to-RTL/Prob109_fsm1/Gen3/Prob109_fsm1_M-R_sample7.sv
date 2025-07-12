module TopModule(
    input           clk,
    input           areset,
    input           in,
    output          out
);

reg state; // 1 represents state B, 0 represents state A

// Sequential logic to update current state
always @(posedge clk or posedge areset)
begin
    if (areset) state <= 1; // Reset to state B
    else
    begin
        case(state)
            1: state <= in ? 1 : 0; // In state B, stay if in is 1, go to A if in is 0
            0: state <= in ? 0 : 1; // In state A, stay if in is 1, go to B if in is 0
            default: state <= 1; // Default to state B
        endcase
    end
end

// Output logic (Moore machine, output based on current state)
assign out = state;

endmodule