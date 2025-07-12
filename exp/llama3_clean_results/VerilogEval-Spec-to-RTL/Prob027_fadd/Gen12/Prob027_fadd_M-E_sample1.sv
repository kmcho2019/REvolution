module TopModule(
    input a,
    input b,
    input cin,
    output reg cout,
    output reg sum
);

// Define the lookup table
reg [1:0] lut_sum [7:0];
reg [0:0] lut_cout [7:0];

initial begin
    // Initialize the lookup table with precomputed values
    lut_sum[0] = 2'b000; lut_cout[0] = 1'b0; // a=0, b=0, cin=0
    lut_sum[1] = 2'b001; lut_cout[1] = 1'b0; // a=0, b=0, cin=1
    lut_sum[2] = 2'b001; lut_cout[2] = 1'b0; // a=0, b=1, cin=0
    lut_sum[3] = 2'b010; lut_cout[3] = 1'b0; // a=0, b=1, cin=1
    lut_sum[4] = 2'b001; lut_cout[4] = 1'b0; // a=1, b=0, cin=0
    lut_sum[5] = 2'b010; lut_cout[5] = 1'b0; // a=1, b=0, cin=1
    lut_sum[6] = 2'b010; lut_cout[6] = 1'b0; // a=1, b=1, cin=0
    lut_sum[7] = 2'b011; lut_cout[7] = 1'b1; // a=1, b=1, cin=1
end

always @(*) begin
    // Concatenate inputs to form the index
    reg [2:0] index;
    index = {a, b, cin};
    // Look up the values in the table
    sum = lut_sum[index][0];
    cout = lut_cout[index];
end

endmodule