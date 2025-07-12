module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Pre-compute all possible shift results
wire [63:0] shift_left_1  = {q[62:0], 1'b0};
wire [63:0] shift_left_8  = {q[55:0], 8'b0};
wire [63:0] shift_right_1 = {q[63], q[63:1]};
wire [63:0] shift_right_8 = {{8{q[63]}}, q[63:8]};

// Shift selection using case statement
reg [63:0] shifted_value;
always @(*) begin
    case (amount)
        2'b00: shifted_value = shift_left_1;
        2'b01: shifted_value = shift_left_8;
        2'b10: shifted_value = shift_right_1;
        2'b11: shifted_value = shift_right_8;
        default: shifted_value = q;
    endcase
end

// Next state logic
wire [63:0] next_q = load ? data : (ena ? shifted_value : q);

always @(posedge clk) begin
    q <= next_q;
end

endmodule