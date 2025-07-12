module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// One-hot encoded state vector: bit 0 = A, bit 1 = B
reg [1:0] state;
wire [1:0] next_state;

// Next state logic as continuous assignments
assign next_state[0] = (state[0] & ~x); // from A to A if x=0
assign next_state[1] = (state[0] & x) | state[1]; // from A to B if x=1, stay in B

// Output logic (Mealy): depends on current state and input x
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