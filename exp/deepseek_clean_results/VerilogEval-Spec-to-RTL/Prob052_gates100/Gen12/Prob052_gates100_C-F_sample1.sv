module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Process 4 slices of 25 bits each
    wire [3:0] slice_and = {
        &in[99:75],
        &in[74:50],
        &in[49:25],
        &in[24:0]
    };
    
    wire [3:0] slice_or = {
        |in[99:75],
        |in[74:50],
        |in[49:25],
        |in[24:0]
    };
    
    wire [3:0] slice_xor = {
        ^in[99:75],
        ^in[74:50],
        ^in[49:25],
        ^in[24:0]
    };

    // Combine slice results
    assign out_and = &slice_and;
    assign out_or  = |slice_or;
    assign out_xor = ^slice_xor;

endmodule