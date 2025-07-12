module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Simple conditional assignment for clear mux functionality
    assign out = sel ? b : a;

endmodule