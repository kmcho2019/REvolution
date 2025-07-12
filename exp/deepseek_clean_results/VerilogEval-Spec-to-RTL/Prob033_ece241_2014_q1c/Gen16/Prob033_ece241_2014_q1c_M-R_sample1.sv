module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Perform signed addition
    wire [8:0] sum_ext;
    assign sum_ext = {a[7], a} + {b[7], b};
    assign s = sum_ext[7:0];
    
    // Overflow occurs when:
    // 1. Both inputs have same sign (MSBs)
    // 2. Result has different sign than inputs
    assign overflow = (a[7] == b[7]) & (s[7] != a[7]);
endmodule