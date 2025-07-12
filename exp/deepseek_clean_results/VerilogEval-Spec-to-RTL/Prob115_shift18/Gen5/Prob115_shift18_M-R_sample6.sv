module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Shift control signals
wire shift_left  = (amount[1] == 1'b0);
wire shift_8bits = (amount[0] == 1'b1);

// Shift operations
wire [63:0] shift_left_1  = {q[62:0], 1'b0};
wire [63:0] shift_left_8  = {q[55:0], 8'b0};
wire [63:0] shift_right_1 = q >>> 1;
wire [63:0] shift_right_8 = q >>> 8;

// Selected shift result
wire [63:0] shift_result = 
    shift_left ? (shift_8bits ? shift_left_8 : shift_left_1) :
                 (shift_8bits ? shift_right_8 : shift_right_1);

// Next state logic
wire [63:0] next_q = load ? data : (ena ? shift_result : q);

// Register update
always @(posedge clk) begin
    q <= next_q;
end

endmodule