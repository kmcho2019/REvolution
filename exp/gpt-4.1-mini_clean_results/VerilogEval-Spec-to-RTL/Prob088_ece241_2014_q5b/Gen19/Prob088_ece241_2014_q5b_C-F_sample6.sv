module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

reg state_A;

// Next state logic (combinational)
wire next_state_A = state_A & ~x;

// Mealy output logic (combinational)
wire z_int = state_A ? x : ~x;

// Sequential logic with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state_A <= 1'b1;  // reset to state A
    else
        state_A <= next_state_A;
end

assign z = z_int;

endmodule