// TopModule implements half-adder logic using a lookup table approach
module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
// Define the lookup table for the sum and carry-out
logic [1:0] lut_sum [1:0];
logic [1:0] lut_cout [1:0];

// Initialize the lookup tables
initial begin
    lut_sum[0] = 2'b00; // a=0, b=0
    lut_sum[1] = 2'b01; // a=0, b=1
    lut_cout[0] = 2'b00; // a=0, b=0
    lut_cout[1] = 2'b00; // a=0, b=1
    lut_sum[2] = 2'b01; // a=1, b=0
    lut_sum[2] = 2'b01; // a=1, b=0
    lut_cout[2] = 2'b00; // a=1, b=0
    lut_cout[2] = 2'b00; // a=1, b=0
    lut_sum[3] = 2'b10; // a=1, b=1
    lut_cout[3] = 2'b01; // a=1, b=1
end

// Use the input bits as indices to retrieve the output values from the lookup tables
assign sum = (a == 1'b0 && b == 1'b0) ? lut_sum[0][0] :
             (a == 1'b0 && b == 1'b1) ? lut_sum[1][0] :
             (a == 1'b1 && b == 1'b0) ? lut_sum[2][0] :
             (a == 1'b1 && b == 1'b1) ? lut_sum[3][0] : 1'b0;

assign cout = (a == 1'b0 && b == 1'b0) ? lut_cout[0][1] :
              (a == 1'b0 && b == 1'b1) ? lut_cout[1][1] :
              (a == 1'b1 && b == 1'b0) ? lut_cout[2][1] :
              (a == 1'b1 && b == 1'b1) ? lut_cout[3][1] : 1'b0;
endmodule