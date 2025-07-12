module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Using case statement for potential better synthesis optimization
    assign out = (sel) ? a : b;

endmodule