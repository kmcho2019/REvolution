module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);

    // Convert inputs to signed numbers and perform addition
    wire signed [8:0] sum_ext = $signed(a) + $signed(b);

    // Assign the result to the output s
    assign s = sum_ext[7:0];

    // Detect overflow by comparing MSBs
    assign overflow = (a[7] == b[7] && a[7]!= sum_ext[8]);

endmodule