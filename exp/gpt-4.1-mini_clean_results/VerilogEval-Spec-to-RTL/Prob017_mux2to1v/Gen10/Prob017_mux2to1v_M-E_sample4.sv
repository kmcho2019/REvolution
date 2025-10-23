module TopModule (
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Single vector 2-to-1 mux: choose entire vector 'a' or 'b' based on sel
    assign out = sel ? b : a;
endmodule