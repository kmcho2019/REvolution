module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // Directly calculate the count of '1's in the input vector
    assign out = ({2{in[0]}} + {2{in[1]}} + {2{in[2]}})[1:0];

endmodule