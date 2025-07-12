module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

// Define the LUT for BCD addition results
reg [3:0] lut_sum [0:255];
reg [0:0] lut_cout [0:255];

// Initialize the LUT
initial begin
    for (int i = 0; i < 256; i++) begin
        reg [3:0] a = i >> 1;
        reg [3:0] b = i & 4'd1;
        reg cin_temp = i & 1;
        
        reg [4:0] temp_sum = a + b + cin_temp;
        
        if (temp_sum > 9 || temp_sum[4]) begin
            lut_sum[i] = (temp_sum[3:0] + 4'd6);
            lut_cout[i] = 1'b1;
        end else begin
            lut_sum[i] = temp_sum[3:0];
            lut_cout[i] = 1'b0;
        end
    end
end

// Index into the LUT using A, B, and Cin
wire [7:0] index = {A, B, Cin};
assign Sum = lut_sum[index];
assign Cout = lut_cout[index];

endmodule