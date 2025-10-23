module TopModule(
    input a,
    input b,
    input cin,
    output reg cout,
    output reg sum
);

// Precomputed look-up table for sum and carry-out
reg [1:0] lut_sum [7:0];
reg [0:0] lut_cout [7:0];

initial begin
    // Initialize the look-up table with precomputed values
    lut_sum[0] = 0; lut_cout[0] = 0; // a=0, b=0, cin=0
    lut_sum[1] = 1; lut_cout[1] = 0; // a=0, b=0, cin=1
    lut_sum[2] = 1; lut_cout[2] = 0; // a=0, b=1, cin=0
    lut_sum[3] = 0; lut_cout[3] = 1; // a=0, b=1, cin=1
    lut_sum[4] = 1; lut_cout[4] = 0; // a=1, b=0, cin=0
    lut_sum[5] = 0; lut_cout[5] = 1; // a=1, b=0, cin=1
    lut_sum[6] = 0; lut_cout[6] = 1; // a=1, b=1, cin=0
    lut_sum[7] = 1; lut_cout[7] = 1; // a=1, b=1, cin=1
end

always @(*) begin
    // Create a 3-bit index from the inputs
    reg [2:0] index;
    index = {a, b, cin};
    
    // Use the look-up table to retrieve the sum and carry-out
    sum = lut_sum[index][0];
    cout = lut_cout[index][0];
end

endmodule