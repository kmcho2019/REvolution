// Define the half adder module
module half_adder(
    input  a,  // input bit
    input  b,  // input bit
    output sum,  // sum bit
    output cout  // carry-out
);
    
    assign sum = a ^ b;
    assign cout = a & b;
    
endmodule

// Define the 4-bit adder module using half adders and OR gates
module FourBitAdder(
    input  [3:0] a,  
    input  [3:0] b,  
    output [3:0] sum,  
    output      cout  // carry-out
);
    
    wire [3:0] temp_sum;
    wire [2:0] temp_cout;
    
    half_adder ha0(a[0], b[0], temp_sum[0], temp_cout[0]);
    half_adder ha1(a[1], b[1], temp_sum[1], temp_cout[1]);
    half_adder ha2(a[2], b[2], temp_sum[2], temp_cout[2]);
    half_adder ha3(a[3], b[3], temp_sum[3], temp_cout[3]);
    
    assign sum[0] = temp_sum[0];
    assign sum[1] = temp_sum[1] ^ temp_cout[0];
    assign sum[2] = temp_sum[2] ^ temp_cout[1];
    assign sum[3] = temp_sum[3] ^ temp_cout[2];
    assign cout = temp_cout[2] | (temp_sum[3] & temp_cout[2]);
    
endmodule

// Define the 8-bit adder module using two 4-bit adders
module EightBitAdder(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] sum,  
    output      cout  // carry-out
);
    
    wire [3:0] sum_low;
    wire [3:0] sum_high;
    wire cout_low;
    wire cout_high;
    
    FourBitAdder fa_low(a[3:0], b[3:0], sum_low, cout_low);
    FourBitAdder fa_high(a[7:4], b[7:4], sum_high, cout_high);
    
    assign sum[3:0] = sum_low;
    assign sum[7:4] = sum_high ^ {4{cout_low}};
    assign cout = cout_high | (sum_high[3] & cout_low);
    
endmodule

// Define the TopModule
module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);
    
    wire [7:0] sum;
    wire cout;
    
    EightBitAdder adder(
       .a(a),
       .b(b),
       .sum(sum),
       .cout(cout)
    );
    
    assign s = sum;
    assign overflow = (a[7] == b[7] && a[7] != sum[7]);
    
endmodule