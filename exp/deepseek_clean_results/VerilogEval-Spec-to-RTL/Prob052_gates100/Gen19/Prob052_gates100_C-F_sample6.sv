module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Optimized slice definitions - 5 slices of 20 bits for better XOR performance
    wire [4:0] slice_and = {
        &in[99:80],
        &in[79:60],
        &in[59:40],
        &in[39:20],
        &in[19:0]
    };
    
    wire [4:0] slice_or = {
        |in[99:80],
        |in[79:60],
        |in[59:40],
        |in[39:20],
        |in[19:0]
    };
    
    wire [4:0] slice_xor = {
        ^in[99:80],
        ^in[79:60],
        ^in[59:40],
        ^in[39:20],
        ^in[19:0]
    };

    // Direct final computation using reduction operators
    assign out_and = &slice_and;
    assign out_or  = |slice_or;
    assign out_xor = ^slice_xor;

endmodule