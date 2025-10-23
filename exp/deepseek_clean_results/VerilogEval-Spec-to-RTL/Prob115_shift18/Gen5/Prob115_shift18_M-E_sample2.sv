module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Pre-compute all possible shift results
wire [63:0] shift_left_1 = {q[62:0], 1'b0};
wire [63:0] shift_left_8 = {q[55:0], 8'b0};
wire [63:0] shift_right_1 = {q[63], q[63:1]};
wire [63:0] shift_right_8 = {{8{q[63]}}, q[63:8]};

// One-hot encoded shift selection
wire [3:0] shift_sel = {
    amount == 2'b00,  // left 1
    amount == 2'b01,  // left 8
    amount == 2'b10,  // right 1
    amount == 2'b11   // right 8
};

// Combined shift result
wire [63:0] shifted_value = 
    ({64{shift_sel[0]}} & shift_left_1) |
    ({64{shift_sel[1]}} & shift_left_8) |
    ({64{shift_sel[2]}} & shift_right_1) |
    ({64{shift_sel[3]}} & shift_right_8);

// Update logic with enable gating
always @(posedge clk) begin
    if (load)
        q <= data;
    else if (ena)
        q <= shifted_value;
end

endmodule