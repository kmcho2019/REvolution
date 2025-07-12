module TopModule(
    input [2:0] in,  
    output [1:0] out 
);
    // Directly calculate the population count by adding the bits
    assign out = {1'b0, in[0]} + {1'b0, in[1]} + {1'b0, in[2]};
endmodule