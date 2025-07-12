module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

reg [15:0] temp_dividend;
reg [15:0] temp_quotient;
reg [15:0] temp_remainder;

assign temp_dividend = A;
assign temp_quotient = 0;

// Compare the higher bits of the dividend with the divisor
assign result[15] = (temp_dividend[15:8] >= B) ? 1'b1 : 1'b0;
assign temp_remainder[15:8] = (temp_dividend[15:8] >= B) ? (temp_dividend[15:8] - B) : temp_dividend[15:8];
assign temp_remainder[7:0] = temp_dividend[7:0];

// Shift the dividend to the right
assign result[14] = (temp_remainder[14:7] >= B) ? 1'b1 : 1'b0;
assign temp_remainder[14:7] = (temp_remainder[14:7] >= B) ? (temp_remainder[14:7] - B) : temp_remainder[14:7];
assign temp_remainder[6:0] = {temp_remainder[13:7], 1'b0};

// Repeat the process for the remaining bits
assign result[13] = (temp_remainder[13:6] >= B) ? 1'b1 : 1'b0;
assign temp_remainder[13:6] = (temp_remainder[13:6] >= B) ? (temp_remainder[13:6] - B) : temp_remainder[13:6];
assign temp_remainder[5:0] = {temp_remainder[12:6], 1'b0};

assign result[12] = (temp_remainder[12:5] >= B) ? 1'b1 : 1'b0;
assign temp_remainder[12:5] = (temp_remainder[12:5] >= B) ? (temp_remainder[12:5] - B) : temp_remainder[12:5];
assign temp_remainder[4:0] = {temp_remainder[11:5], 1'b0};

assign result[11] = (temp_remainder[11:4] >= B) ? 1'b1 : 1'b0;
assign temp_remainder[11:4] = (temp_remainder[11:4] >= B) ? (temp_remainder[11:4] - B) : temp_remainder[11:4];
assign temp_remainder[3:0] = {temp_remainder[10:4], 1'b0};

assign result[10] = (temp_remainder[10:3] >= B) ? 1'b1 : 1'b0;
assign temp_remainder[10:3] = (temp_remainder[10:3] >= B) ? (temp_remainder[10:3] - B) : temp_remainder[10:3];
assign temp_remainder[2:0] = {temp_remainder[9:3], 1'b0};

assign result[9] = (temp_remainder[9:2] >= B) ? 1'b1 : 1'b0;
assign temp_remainder[9:2] = (temp_remainder[9:2] >= B) ? (temp_remainder[9:2] - B) : temp_remainder[9:2];
assign temp_remainder[1:0] = {temp_remainder[8:2], 1'b0};

assign result[8] = (temp_remainder[8:1] >= B) ? 1'b1 : 1'b0;
assign temp_remainder[8:1] = (temp_remainder[8:1] >= B) ? (temp_remainder[8:1] - B) : temp_remainder[8:1];
assign temp_remainder[0] = temp_remainder[7:1];

assign result[7:0] = temp_remainder[7:0];
assign odd = {8'd0, temp_remainder[7:0]};

endmodule