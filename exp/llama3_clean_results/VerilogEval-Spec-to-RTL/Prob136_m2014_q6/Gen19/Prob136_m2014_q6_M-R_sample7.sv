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

// Combinational logic for next state using assign statements
assign next_state = 
    (state == A && w) ? A :
    (state == A && ~w) ? B :
    (state == B && w) ? D :
    (state == B && ~w) ? C :
    (state == C && w) ? D :
    (state == C && ~w) ? E :
    (state == D && w) ? A :
    (state == D && ~w) ? F :
    (state == E && w) ? D :
    (state == E && ~w) ? E :
    (state == F && w) ? D :
    (state == F && ~w) ? C :
    A;

// Combinational logic for output z
assign z = (state == E) || (state == F);

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) state <= A;
    else state <= next_state;
end

endmodule