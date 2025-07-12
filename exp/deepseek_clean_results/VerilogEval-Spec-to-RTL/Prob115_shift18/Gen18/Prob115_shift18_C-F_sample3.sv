module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Control signal decoding
wire shift_left = ~amount[1];
wire shift_by_8 = amount[0];

// Shift operations (computed in parallel)
wire [63:0] left_shift_1 = {q[62:0], 1'b0};
wire [63:0] left_shift_8 = {q[55:0], 8'b0};
wire [63:0] right_shift_1 = {q[63], q[63:1]};
wire [63:0] right_shift_8 = {{8{q[63]}}, q[63:8]};

// Selected shift result
wire [63:0] left_shift = shift_by_8 ? left_shift_8 : left_shift_1;
wire [63:0] right_shift = shift_by_8 ? right_shift_8 : right_shift_1;
wire [63:0] shifted_val = shift_left ? left_shift : right_shift;

// Next state logic
wire [63:0] next_q = load ? data : (ena ? shifted_val : q);

// Clock-gated register update
always @(posedge clk) begin
    q <= next_q;
end

endmodule