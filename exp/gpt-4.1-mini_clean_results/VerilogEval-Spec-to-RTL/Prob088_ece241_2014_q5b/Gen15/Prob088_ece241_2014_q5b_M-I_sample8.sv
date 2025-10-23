module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// One-hot encoded state stored in a 2-bit register: 
// state[1] = state B, state[0] = state A
reg [1:0] state;

// Next state logic
wire [1:0] next_state = (areset) ? 2'b01 : // reset to state A synchronously
                        (state[0] & ~x) ? 2'b01 :  // stay in A if x=0
                        (state[0] & x)  ? 2'b10 :  // A->B if x=1
                        (state[1])      ? 2'b10 :  // stay in B
                        2'b01;                   // default to A to avoid latches

// Sequential logic with synchronous reset for simpler timing and power
always @(posedge clk) begin
    if (areset) begin
        state <= 2'b01;  // Reset to state A
    end else begin
        state <= next_state;
    end
end

// Mealy output logic (combinational)
// z=1 when (state A and x=1) or (state B and x=0)
assign z = (state[0] & x) | (state[1] & ~x);

endmodule