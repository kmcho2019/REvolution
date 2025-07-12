module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// One-hot decoded shift control
wire shift_left_1  = ena & ~load & (amount == 2'b00);
wire shift_left_8  = ena & ~load & (amount == 2'b01);
wire shift_right_1 = ena & ~load & (amount == 2'b10);
wire shift_right_8 = ena & ~load & (amount == 2'b11);

// Pre-compute all shift options
wire [63:0] left_shift_1  = {q[62:0], 1'b0};
wire [63:0] left_shift_8  = {q[55:0], 8'b0};
wire [63:0] right_shift_1 = {q[63], q[63:1]};
wire [63:0] right_shift_8 = {{8{q[63]}}, q[63:8]};

// Final shift selection
wire [63:0] shifted_val = 
    (shift_left_1)  ? left_shift_1  :
    (shift_left_8)  ? left_shift_8  :
    (shift_right_1) ? right_shift_1 :
    (shift_right_8) ? right_shift_8 :
    q;  // default hold value

// Register update with load priority
always @(posedge clk) begin
    if (load)
        q <= data;
    else if (ena)
        q <= shifted_val;
end

endmodule