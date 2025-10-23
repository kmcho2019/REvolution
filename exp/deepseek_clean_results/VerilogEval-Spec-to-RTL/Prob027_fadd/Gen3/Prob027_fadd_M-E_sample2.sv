module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

    // Sum calculation using mux-based XOR
    assign sum = (a & b & cin) ? 1'b0 :
                (a & b & ~cin) ? 1'b1 :
                (a & ~b & cin) ? 1'b0 :
                (a & ~b & ~cin) ? 1'b1 :
                (~a & b & cin) ? 1'b0 :
                (~a & b & ~cin) ? 1'b1 :
                (~a & ~b & cin) ? 1'b1 :
                1'b0;

    // Carry calculation using mux-based majority function
    assign cout = (a & b) ? 1'b1 :
                 (a & cin) ? 1'b1 :
                 (b & cin) ? 1'b1 :
                 1'b0;

endmodule