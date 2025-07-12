module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

reg state_A;

// Next state logic
wire next_state_A = state_A & ~x;

// Output logic (Mealy) simplified
assign z = state_A ^ ~x;

always @(posedge clk or posedge areset) begin
    if (areset)
        state_A <= 1'b1;
    else
        state_A <= next_state_A;
end

endmodule