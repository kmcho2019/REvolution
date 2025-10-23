module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Using case statement for better optimization
    assign out = sel ? b : a;

    // Alternative implementation using generate for explicit bit-level control
    /*
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : mux_gen
            assign out[i] = sel ? b[i] : a[i];
        end
    endgenerate
    */

endmodule