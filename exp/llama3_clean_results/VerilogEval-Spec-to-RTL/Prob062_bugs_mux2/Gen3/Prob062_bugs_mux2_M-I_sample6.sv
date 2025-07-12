module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    assign out = (sel) ? b : a;

    // Alternative implementation using bitwise operations
    // assign out = (~sel & {8{1'b1}}) ? a : b;
    // assign out = (sel) ? {8{1'b0}} | b : {8{1'b0}} | a;

    // A more traditional approach using bitwise operations for a 2-to-1 mux
    // assign out = (~sel) ? a : b;

endmodule