module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Common sign bit for arithmetic right shifts
wire sign_bit = q[63];

// Precompute all shift operations
wire [63:0] shift_left_1  = {q[62:0], 1'b0};
wire [63:0] shift_left_8  = {q[55:0], 8'b0};
wire [63:0] shift_right_1 = {sign_bit, q[63:1]};
wire [63:0] shift_right_8 = {{8{sign_bit}}, q[63:8]};

// Next state logic with clear case structure
wire [63:0] next_q = 
    (amount == 2'b00) ? shift_left_1 :
    (amount == 2'b01) ? shift_left_8 :
    (amount == 2'b10) ? shift_right_1 :
    /* default */      shift_right_8;

// Synchronous update with load priority
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else if (ena) begin
        q <= next_q;
    end
end

endmodule