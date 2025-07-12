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

// Sign extension optimization
wire [7:0] sign_byte = {8{q[63]}};  // Compute sign bits once

// Enable-gated shift computation
wire [63:0] enabled_shift_result;
assign enabled_shift_result = ena ? 
    (amount == 2'b00) ? shift_left_1 :
    (amount == 2'b01) ? shift_left_8 :
    (amount == 2'b10) ? shift_right_1 :
    {sign_byte, q[63:8]} : q;

// Next state logic with load priority
wire [63:0] next_q = load ? data : enabled_shift_result;

// Register update
always @(posedge clk) begin
    q <= next_q;
end

endmodule