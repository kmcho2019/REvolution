module TopModule(
    input  clk,
    input  reset,
    input  w,
    output reg z
);

// Define the states
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Define the current state and next state
reg [2:0] current_state;

// Define the lookup tables for next state and output 'z'
reg [2:0] next_state_lut [6][2]; // 6 states, 2 inputs (w = 0, w = 1)
reg [0:0] z_lut [6]; // 6 states

// Initialize the lookup tables
initial begin
    next_state_lut[A][0] = B; next_state_lut[A][1] = A;
    next_state_lut[B][0] = C; next_state_lut[B][1] = D;
    next_state_lut[C][0] = E; next_state_lut[C][1] = D;
    next_state_lut[D][0] = F; next_state_lut[D][1] = A;
    next_state_lut[E][0] = E; next_state_lut[E][1] = D;
    next_state_lut[F][0] = C; next_state_lut[F][1] = D;
    
    z_lut[A] = 0; z_lut[B] = 0; z_lut[C] = 0; z_lut[D] = 0;
    z_lut[E] = 1; z_lut[F] = 1;
end

// Sequential process
always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= A;
        z <= 0; // Initialize z to 0 when reset is asserted
    end else begin
        current_state <= next_state_lut[current_state][w];
        z <= z_lut[current_state];
    end
end

endmodule