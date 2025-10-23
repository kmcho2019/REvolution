module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Control signals
wire shift_right = amount[1];
wire shift_by_8 = amount[0];

// Shift operations - computed only when needed
wire [63:0] shift_left_1 = {q[62:0], 1'b0};
wire [63:0] shift_left_8 = {q[55:0], 8'b0};

// Arithmetic right shifts with optimized sign extension
wire [63:0] shift_right_1 = {q[63], q[63:1]};
wire [63:0] shift_right_8 = {{8{q[63]}}, q[63:8]};

// Combined shift result
wire [63:0] shift_result = shift_right ? 
                          (shift_by_8 ? shift_right_8 : shift_right_1) :
                          (shift_by_8 ? shift_left_8 : shift_left_1);

// Next state logic with enable gating
wire [63:0] next_q = load ? data : (ena ? shift_result : q);

always @(posedge clk) begin
    q <= next_q;
end

endmodule