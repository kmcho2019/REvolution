module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    // Lower 2 bits (ripple carry)
    wire c0_out;
    wire [1:0] sum_low;
    
    // First full adder
    assign sum_low[0] = x[0] ^ y[0];
    assign c0_out = x[0] & y[0];
    
    // Second full adder
    assign sum_low[1] = x[1] ^ y[1] ^ c0_out;
    wire c1_out = (x[1] & y[1]) | ((x[1] ^ y[1]) & c0_out);
    
    // Upper 2 bits (carry-select)
    // Case 0: carry-in = 0
    wire [1:0] sum_high_0;
    assign sum_high_0[0] = x[2] ^ y[2];
    wire c2_0 = x[2] & y[2];
    assign sum_high_0[1] = x[3] ^ y[3] ^ c2_0;
    wire c3_0 = (x[3] & y[3]) | ((x[3] ^ y[3]) & c2_0);
    
    // Case 1: carry-in = 1
    wire [1:0] sum_high_1;
    assign sum_high_1[0] = x[2] ^ y[2] ^ 1'b1;
    wire c2_1 = (x[2] & y[2]) | ((x[2] | y[2]) & 1'b1);
    assign sum_high_1[1] = x[3] ^ y[3] ^ c2_1;
    wire c3_1 = (x[3] & y[3]) | ((x[3] ^ y[3]) & c2_1);
    
    // Mux selection
    wire [1:0] sum_high = c1_out ? sum_high_1 : sum_high_0;
    wire c_out = c1_out ? c3_1 : c3_0;
    
    // Combine results
    assign sum[1:0] = sum_low;
    assign sum[3:2] = sum_high;
    assign sum[4] = c_out;
endmodule