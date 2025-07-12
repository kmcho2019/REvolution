module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// One-hot state encoding: state[0] = A, state[1] = B
reg [1:0] state;
wire [1:0] next_state;

// State encoding parameters for clarity
localparam A = 2'b01;
localparam B = 2'b10;

// Next state logic (combinational)
assign next_state = (state == A) ? (x ? B : A) : B;

// Output logic (Mealy): 
// z = x when in A, z = ~x when in B
assign z = (state == A) ? x : ~x;

// Sequential state update with async reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= A;
    else
        state <= next_state;
end

endmodule