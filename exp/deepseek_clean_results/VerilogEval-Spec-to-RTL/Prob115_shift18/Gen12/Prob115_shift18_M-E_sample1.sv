module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// One-hot shift amount decoding
wire shift_left1  = (amount == 2'b00);
wire shift_left8  = (amount == 2'b01);
wire shift_right1 = (amount == 2'b10);
wire shift_right8 = (amount == 2'b11);

// Pre-compute all shift options
wire [63:0] left_shift1  = {q[62:0], 1'b0};
wire [63:0] left_shift8  = {q[55:0], 8'b0};
wire [63:0] right_shift1 = {q[63], q[63:1]};
wire [63:0] right_shift8 = {{8{q[63]}}, q[63:8]};

// Select appropriate shift result
wire [63:0] shifted_val = 
    (shift_left1)  ? left_shift1  :
    (shift_left8)  ? left_shift8  :
    (shift_right1) ? right_shift1 :
    right_shift8;

// Compute next state
wire [63:0] next_q = load ? data : (ena ? shifted_val : q);

// Clocked register update
always @(posedge clk) begin
    q <= next_q;
end

endmodule