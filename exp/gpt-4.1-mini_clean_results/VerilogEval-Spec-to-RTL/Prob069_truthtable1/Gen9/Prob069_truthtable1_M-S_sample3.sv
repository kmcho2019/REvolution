module TopModule (
    input  wire x3,
    input  wire x2,
    input  wire x1,
    output wire f
);

    // Simplified mux-based implementation
    assign f = x3 ? x1 : x2;

endmodule