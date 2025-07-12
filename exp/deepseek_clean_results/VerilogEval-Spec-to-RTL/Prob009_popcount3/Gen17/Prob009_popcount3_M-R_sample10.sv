module TopModule (
    input [2:0] in,
    output [1:0] out
);
    // Count bits using reduction operators
    wire [1:0] count = {1'b0, in[0]} + {1'b0, in[1]} + {1'b0, in[2]};
    assign out = count;
endmodule