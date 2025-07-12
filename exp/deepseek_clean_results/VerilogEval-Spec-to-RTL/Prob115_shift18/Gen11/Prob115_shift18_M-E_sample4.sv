module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Sign bit for arithmetic right shifts
wire sign_bit = q[63];

// Shift computation only when enabled
wire [63:0] shifted_value;
assign shifted_value = 
    !ena ? q :  // No shift when not enabled
    load ? data :  // Load takes priority
    (amount == 2'b00) ? {q[62:0], 1'b0} :  // Left 1
    (amount == 2'b01) ? {q[55:0], 8'b0} :  // Left 8
    (amount == 2'b10) ? {sign_bit, q[63:1]} :  // Right 1
    /* 2'b11 */ {{8{sign_bit}}, q[63:8]};  // Right 8

always @(posedge clk) begin
    q <= shifted_value;
end

endmodule