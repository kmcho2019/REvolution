module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states as parameters using binary encoding
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Define the state register using binary encoding
reg [1:0] state;
reg [1:0] next_state;

// Combinational logic to determine the next state
always @(*) begin
    case (state)
        A: next_state = w ? A : B;
        B: next_state = w ? D : C;
        C: next_state = w ? D : 2'b11; // corrected state E
        D: next_state = w ? A : 2'b10; // corrected state F
        2'b11: next_state = w ? D : 2'b11; // state E
        2'b10: next_state = w ? D : C; // state F
        default: next_state = A;
    endcase
end

// Combinational logic for output z
assign z = (state == 2'b11) || (state == 2'b10);

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) state <= A;
    else state <= next_state;
end

endmodule