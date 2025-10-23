module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Parameterized shift amounts
localparam SHIFT_LEFT_1  = 2'b00;
localparam SHIFT_LEFT_8  = 2'b01;
localparam SHIFT_RIGHT_1 = 2'b10;
localparam SHIFT_RIGHT_8 = 2'b11;

// Gated shift computations
wire [63:0] shift_left_1  = ena ? {q[62:0], 1'b0} : q;
wire [63:0] shift_left_8  = ena ? {q[55:0], 8'b0} : q;
wire [63:0] shift_right_1 = ena ? {q[63], q[63:1]} : q;
wire [63:0] shift_right_8 = ena ? {{8{q[63]}}, q[63:8]} : q;

// Pre-computed sign extension for right shifts
wire [7:0] sign_ext = {8{q[63]}};

// Optimized next state logic
wire [63:0] next_q;
assign next_q = load ? data :          // Highest priority: load
               (amount == SHIFT_LEFT_1)  ? shift_left_1 :
               (amount == SHIFT_LEFT_8)  ? shift_left_8 :
               (amount == SHIFT_RIGHT_1) ? shift_right_1 :
               (amount == SHIFT_RIGHT_8) ? shift_right_8 :
               q;                       // Default: hold value

// Clock-gated register update
always @(posedge clk) begin
    q <= next_q;
end

endmodule