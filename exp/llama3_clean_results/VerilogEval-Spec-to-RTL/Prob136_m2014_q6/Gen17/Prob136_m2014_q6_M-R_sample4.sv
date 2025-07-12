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

// Define the state register using one-hot encoding
reg [5:0] state;
reg [5:0] next_state;

// Combinational logic for next state using logical operations
assign next_state = (
    (state == A && w == 0)? B :
    (state == A && w == 1)? A :
    (state == B && w == 0)? C :
    (state == B && w == 1)? D :
    (state == C && w == 0)? E :
    (state == C && w == 1)? D :
    (state == D && w == 0)? F :
    (state == D && w == 1)? A :
    (state == E && w == 0)? E :
    (state == E && w == 1)? D :
    (state == F && w == 0)? C :
    (state == F && w == 1)? D :
    A
);

// Combinational logic for output z
assign z = (state == E || state == F);

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) state <= A;
    else state <= next_state;
end

endmodule