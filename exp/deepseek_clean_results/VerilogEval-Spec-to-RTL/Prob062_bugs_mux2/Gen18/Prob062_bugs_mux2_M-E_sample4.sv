module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    wire [7:0] mask = {8{sel}};  // Replicate sel bit 8 times
    
    assign out = (a & ~mask) | (b & mask);

endmodule