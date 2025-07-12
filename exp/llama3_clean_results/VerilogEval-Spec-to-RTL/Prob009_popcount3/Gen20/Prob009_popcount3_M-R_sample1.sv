module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Refactored code using assign statement with ternary operator
    assign out = ({2{in[2]}} + {2{in[1]}} + {2{in[0]}}) >= 3? 2'd3 : 
                 ({2{in[2]}} + {2{in[1]}} + {2{in[0]}}) >= 2? 2'd2 : 
                 ({2{in[2]}} + {2{in[1]}} + {2{in[0]}}) >= 1? 2'd1 : 2'd0;

    // Alternative implementation using bitwise operations and conditional statements
    // assign out = (in[0]? 1 : 0) + (in[1]? 1 : 0) + (in[2]? 1 : 0);

endmodule