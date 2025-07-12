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

// Define the state transition LUT
reg [2:0] state_lut [8];
initial begin
    state_lut[A] = (w == 1)? A : B;
    state_lut[B] = (w == 1)? D : C;
    state_lut[C] = (w == 1)? D : E;
    state_lut[D] = (w == 1)? A : F;
    state_lut[E] = (w == 1)? D : E;
    state_lut[F] = (w == 1)? D : C;
end

// Combinational logic to determine the next state
always @(*) begin
    case (state)
        A: next_state = state_lut[A];
        B: next_state = state_lut[B];
        C: next_state = state_lut[C];
        D: next_state = state_lut[D];
        E: next_state = state_lut[E];
        F: next_state = state_lut[F];
        default: next_state = A;
    endcase
end

// Combinational logic for output z
always @(*) begin
    case (state)
        A: z = 0;
        B: z = 0;
        C: z = 0;
        D: z = 0;
        E: z = 1;
        F: z = 1;
        default: z = 0;
    endcase
end

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) state <= A;
    else state <= next_state;
end

endmodule