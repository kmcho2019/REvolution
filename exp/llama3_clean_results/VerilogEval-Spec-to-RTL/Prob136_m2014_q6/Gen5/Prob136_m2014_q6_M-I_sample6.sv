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

// Combinational logic to determine the next state
always @(*) begin
    next_state = 6'b0;
    if (state == A) next_state = (w == 1) ? A : B;
    else if (state == B) next_state = (w == 1) ? D : C;
    else if (state == C) next_state = (w == 1) ? D : E;
    else if (state == D) next_state = (w == 1) ? A : F;
    else if (state == E) next_state = (w == 1) ? D : E;
    else if (state == F) next_state = (w == 1) ? D : C;
    else next_state = A;
end

// Combinational logic for output z
always @(*) begin
    if (state == E || state == F) z = 1;
    else z = 0;
end

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) state <= A;
    else state <= next_state;
end

endmodule