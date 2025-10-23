module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Decode shift control signals
wire shift_left_1  = ena & ~load & (amount == 2'b00);
wire shift_left_8  = ena & ~load & (amount == 2'b01);
wire shift_right_1 = ena & ~load & (amount == 2'b10);
wire shift_right_8 = ena & ~load & (amount == 2'b11);

// Compute each shift operation separately
wire [63:0] left_shift_1  = q << 1;
wire [63:0] left_shift_8  = q << 8;
wire [63:0] right_shift_1 = {q[63], q[63:1]};  // Arithmetic right by 1
wire [63:0] right_shift_8 = {{8{q[63]}}, q[63:8]};  // Arithmetic right by 8

// Select appropriate shift result
wire [63:0] shift_result = 
    shift_left_1  ? left_shift_1  :
    shift_left_8  ? left_shift_8  :
    shift_right_1 ? right_shift_1 :
    shift_right_8 ? right_shift_8 :
    q;

// Next state logic with clear priority
wire [63:0] next_q = load ? data : shift_result;

// Register update
always @(posedge clk) begin
    q <= next_q;
end

endmodule