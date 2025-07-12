module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Control signal decoding
wire shift_left_1  = ~amount[1] & ~amount[0];
wire shift_left_8  = ~amount[1] &  amount[0];
wire shift_right_1 =  amount[1] & ~amount[0];
wire shift_right_8 =  amount[1] &  amount[0];

// Pre-compute all possible shift operations
wire [63:0] left_shift_1  = {q[62:0], 1'b0};
wire [63:0] left_shift_8  = {q[55:0], 8'b0};
wire [63:0] right_shift_1 = {q[63], q[63:1]};
wire [63:0] right_shift_8 = {{8{q[63]}}, q[63:8]};

// Select appropriate shift based on amount
wire [63:0] shifted_value = 
    (shift_left_1)  ? left_shift_1  :
    (shift_left_8)  ? left_shift_8  :
    (shift_right_1) ? right_shift_1 :
    (shift_right_8) ? right_shift_8 :
    q;

// Apply enable and load conditions
wire [63:0] next_q = load ? data : (ena ? shifted_value : q);

// Register update
always @(posedge clk) begin
    q <= next_q;
end

endmodule