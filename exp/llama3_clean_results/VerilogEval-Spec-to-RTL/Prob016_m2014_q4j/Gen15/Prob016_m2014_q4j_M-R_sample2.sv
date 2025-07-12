module TopModule(x, y, sum);
    input [3:0] x;
    input [3:0] y;
    output [4:0] sum;
    
    // Directly add the two input vectors
    assign sum = {1'b0, x} + {1'b0, y};
    
    // The overflow bit is already included in the sum
endmodule