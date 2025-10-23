module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states as parameters using one-hot encoding
parameter A = 6'b000001;
parameter B = 6'b000010;
parameter C = 6'b000100;
parameter D = 6'b001000;
parameter E = 6'b010000;
parameter F = 6'b100000;

// Define the state register
reg [5:0] state;
reg [5:0] next_state;

// Combinational logic for next state using a multiplexer-based approach
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
assign z = (state == E) || (state == F);

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) state <= A;
    else state <= next_state;
end

endmodule