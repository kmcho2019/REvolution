module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states as parameters using Gray code encoding
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b011;
parameter D = 3'b010;
parameter E = 3'b110;
parameter F = 3'b111;

// Define the state register using Gray code encoding
reg [2:0] state;
reg [2:0] next_state;

// Combinational logic for next state using a lookup table approach
always @(*) begin
    case (state)
        A: next_state = (w == 1)? A : B;
        B: next_state = (w == 1)? D : C;
        C: next_state = (w == 1)? D : E;
        D: next_state = (w == 1)? A : F;
        E: next_state = (w == 1)? D : E;
        F: next_state = (w == 1)? D : C;
        default: next_state = A;
    endcase
end

// Combinational logic for output z
assign z = (state[2] == 1 && state[1] == 1) || (state[2] == 1 && state[0] == 1); // Since only E and F set z high

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) state <= A;
    else state <= next_state;
end

endmodule