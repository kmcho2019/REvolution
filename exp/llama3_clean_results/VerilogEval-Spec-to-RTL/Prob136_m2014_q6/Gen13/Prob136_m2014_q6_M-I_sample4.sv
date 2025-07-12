module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states as parameters using binary encoding
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Define the state register using binary encoding
reg [2:0] state;
reg [2:0] next_state;

// Combinational logic to determine the next state
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

// Combinational logic for output z, considering potential simplifications
assign z = (state[2] == 1); // Since only E and F set z high, and they have the MSB set

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) state <= A;
    else state <= next_state;
end

endmodule