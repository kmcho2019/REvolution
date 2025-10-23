module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

wire [63:0] shift_result;
wire [63:0] next_q;
wire [7:0] sign_ext_8 = {8{q[63]}};  // Pre-compute sign extension for 8-bit right shift

always @(*) begin
    case (amount)
        2'b00: shift_result = {q[62:0], 1'b0};          // Left shift by 1
        2'b01: shift_result = {q[55:0], 8'b0};          // Left shift by 8
        2'b10: shift_result = {q[63], q[63:1]};         // Arithmetic right by 1
        2'b11: shift_result = {sign_ext_8, q[63:8]};    // Arithmetic right by 8
    endcase
end

assign next_q = load ? data : (ena ? shift_result : q);

always @(posedge clk) begin
    q <= next_q;
end

endmodule