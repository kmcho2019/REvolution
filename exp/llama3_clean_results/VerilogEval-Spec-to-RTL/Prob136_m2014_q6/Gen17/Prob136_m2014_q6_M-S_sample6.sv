module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states as parameters using Gray code encoding
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b11;
parameter D = 2'b10;

// Define the state register using Gray code encoding
reg [1:0] state;
reg [1:0] next_state;

// Combinational logic for next state
always @(*) begin
    case (state)
        A: next_state = w ? A : B;
        B: next_state = w ? D : C;
        C: next_state = w ? D : C;
        D: next_state = w ? A : D;
        default: next_state = A;
    endcase
end

// Combinational logic for output z
assign z = (state == C);

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) state <= A;
    else state <= next_state;
end

endmodule