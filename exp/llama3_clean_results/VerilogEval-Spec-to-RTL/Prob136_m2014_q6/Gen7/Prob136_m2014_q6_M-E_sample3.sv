module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states as parameters
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Define the state register
reg [2:0] state;
reg [2:0] next_state;

// Define the LUTs for next state and output z
reg [2:0] lut_next_state [8];
reg [0:0] lut_z [8];

// Initialize the LUTs
initial begin
    lut_next_state[A] = (w == 1)? A : B;
    lut_next_state[B] = (w == 1)? D : C;
    lut_next_state[C] = (w == 1)? D : E;
    lut_next_state[D] = (w == 1)? A : F;
    lut_next_state[E] = (w == 1)? D : E;
    lut_next_state[F] = (w == 1)? D : C;
    
    lut_z[A] = 0;
    lut_z[B] = 0;
    lut_z[C] = 0;
    lut_z[D] = 0;
    lut_z[E] = 1;
    lut_z[F] = 1;
end

// Combinational logic to determine the next state and output z
always @(*) begin
    next_state = lut_next_state[state];
    z = lut_z[state];
end

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) state <= A;
    else state <= next_state;
end

endmodule