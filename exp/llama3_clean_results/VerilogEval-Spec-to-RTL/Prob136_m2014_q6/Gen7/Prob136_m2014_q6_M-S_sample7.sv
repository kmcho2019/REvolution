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

// Combinational logic to determine the next state and output z
always @(*) begin
    next_state = state;
    z = 0;
    case (state)
        A: if (w == 1) next_state = A; else next_state = B;
        B: if (w == 1) next_state = D; else next_state = C;
        C: if (w == 1) next_state = D; else next_state = E;
        D: if (w == 1) next_state = A; else next_state = F;
        E: if (w == 1) next_state = D; else next_state = E;
        F: if (w == 1) next_state = D; else next_state = C;
        default: next_state = A;
    endcase
    if (state == E || state == F) z = 1;
end

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) state <= A;
    else state <= next_state;
end

endmodule