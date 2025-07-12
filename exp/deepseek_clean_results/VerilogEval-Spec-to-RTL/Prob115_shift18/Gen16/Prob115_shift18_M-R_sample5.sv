module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Sign bit for arithmetic shifts
wire sign_bit = q[63];

// Shift operations (computed only when enabled)
wire [63:0] shift_left_1  = {q[62:0], 1'b0};
wire [63:0] shift_left_8  = {q[55:0], 8'b0};
wire [63:0] shift_right_1 = {sign_bit, q[63:1]};
wire [63:0] shift_right_8 = {{8{sign_bit}}, q[63:8]};

// Shift selection
wire [63:0] shift_result = 
    ena ? (amount[1] ? 
              (amount[0] ? shift_right_8 : shift_right_1) :
              (amount[0] ? shift_left_8  : shift_left_1)) :
          q;

// Next state with load priority
wire [63:0] next_q = load ? data : shift_result;

// Register update
always @(posedge clk) begin
    q <= next_q;
end

endmodule