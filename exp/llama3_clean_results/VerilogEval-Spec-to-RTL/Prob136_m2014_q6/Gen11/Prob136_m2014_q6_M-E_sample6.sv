module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states as parameters (binary encoding)
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// State register
reg [1:0] state;
reg [1:0] next_state;

// Combinational logic for next state using LUTs
always @(*) begin
    case ({state, w})
        4'b0000: next_state = B;
        4'b0001: next_state = A;
        4'b0100: next_state = C;
        4'b0101: next_state = D;
        4'b1000: next_state = E;
        4'b1001: next_state = D;
        4'b1100: next_state = F;
        4'b1101: next_state = D;
        default: next_state = A;
    endcase
end

// Combinational logic for output z
always @(*) begin
    case ({state, w})
        4'b1000, 4'b1001, 4'b1100, 4'b1101: z = 1;
        default: z = 0;
    endcase
end

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) state <= A;
    else state <= next_state;
end

// Additional state definitions for E and F (not directly used but needed for completeness)
parameter E = 2'b10; // Overlaps with C, handle in logic
parameter F = 2'b11; // Overlaps with D, handle in logic

endmodule