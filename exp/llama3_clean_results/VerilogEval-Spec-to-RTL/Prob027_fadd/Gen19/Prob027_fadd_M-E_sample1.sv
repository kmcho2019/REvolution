// Full Adder Module using Look-Up Table (LUT)
module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

// Define the LUT for sum and carry-out
reg [1:0] lut_sum [7:0];
reg [0:0] lut_cout [7:0];

// Initialize the LUT
initial begin
    lut_sum[0] = 2'b000; lut_cout[0] = 1'b0; // a=0, b=0, cin=0
    lut_sum[1] = 2'b001; lut_cout[1] = 1'b0; // a=0, b=0, cin=1
    lut_sum[2] = 2'b001; lut_cout[2] = 1'b0; // a=0, b=1, cin=0
    lut_sum[3] = 2'b010; lut_cout[3] = 1'b0; // a=0, b=1, cin=1
    lut_sum[4] = 2'b001; lut_cout[4] = 1'b0; // a=1, b=0, cin=0
    lut_sum[5] = 2'b010; lut_cout[5] = 1'b0; // a=1, b=0, cin=1
    lut_sum[6] = 2'b010; lut_cout[6] = 1'b0; // a=1, b=1, cin=0
    lut_sum[7] = 2'b011; lut_cout[7] = 1'b1; // a=1, b=1, cin=1
end

// Use the LUT to compute sum and carry-out
always @(*) begin
    case ({a, b, cin})
        3'b000: {sum, cout} = {lut_sum[0][0], lut_cout[0]};
        3'b001: {sum, cout} = {lut_sum[1][0], lut_cout[1]};
        3'b010: {sum, cout} = {lut_sum[2][0], lut_cout[2]};
        3'b011: {sum, cout} = {lut_sum[3][0], lut_cout[3]};
        3'b100: {sum, cout} = {lut_sum[4][0], lut_cout[4]};
        3'b101: {sum, cout} = {lut_sum[5][0], lut_cout[5]};
        3'b110: {sum, cout} = {lut_sum[6][0], lut_cout[6]};
        3'b111: {sum, cout} = {lut_sum[7][0], lut_cout[7]};
    endcase
end

endmodule