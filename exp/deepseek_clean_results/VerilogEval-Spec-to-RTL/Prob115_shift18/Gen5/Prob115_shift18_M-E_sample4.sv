module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Unified shift amount calculation
wire [5:0] shift_amount = 
    (amount == 2'b00) ? 6'd1 :  // left 1
    (amount == 2'b01) ? 6'd8 :  // left 8
    (amount == 2'b10) ? 6'd63 : // right 1 (rotate left 63)
    (amount == 2'b11) ? 6'd56 : // right 8 (rotate left 56)
    6'd0;

// Dynamic sign extension for right shifts
wire sign_bit = q[63];
wire [63:0] extended_data = 
    (amount[1]) ? {64{sign_bit}} :  // extend sign if right shift
    64'b0;

// Rotating barrel shifter
wire [63:0] rotated_data = 
    (amount[1]) ? (q >> shift_amount) | (extended_data << (64 - shift_amount)) :
    q << shift_amount;

// Enable-gated next state
wire [63:0] next_q = load ? data : (ena ? rotated_data : q);

always @(posedge clk) begin
    q <= next_q;
end

endmodule