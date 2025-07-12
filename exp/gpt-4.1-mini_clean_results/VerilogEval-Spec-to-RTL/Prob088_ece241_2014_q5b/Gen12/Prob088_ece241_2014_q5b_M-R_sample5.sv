module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// One-hot encoded states in 2-bit vector:
// state = 2'b01 for A, 2'b10 for B
reg [1:0] state, next_state;

// Next state logic (combinational) using assign
wire next_A = (state[0] & ~x) | (state[1] & 1'b0); // from A if x=0 stay A; from B never go A
wire next_B = (state[0] & x)  | (state[1] & 1'b1); // from A if x=1 go B; from B stay B

assign next_state = {next_B, next_A};

// Output logic (Mealy): z depends on current state and input
assign z = (state[0] & x) | (state[1] & ~x);

// State register with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // reset to state A
    end else begin
        state <= next_state;
    end
end

endmodule