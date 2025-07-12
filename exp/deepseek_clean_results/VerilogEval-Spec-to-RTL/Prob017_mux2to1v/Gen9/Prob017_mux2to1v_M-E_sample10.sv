module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Transmission gate based 4-bit mux
    module Mux4Bit (
        input  [3:0] a,
        input  [3:0] b,
        input        sel,
        output [3:0] out
    );
        wire sel_n = ~sel;
        
        // Transmission gate implementation
        assign out[0] = (sel & b[0]) | (sel_n & a[0]);
        assign out[1] = (sel & b[1]) | (sel_n & a[1]);
        assign out[2] = (sel & b[2]) | (sel_n & a[2]);
        assign out[3] = (sel & b[3]) | (sel_n & a[3]);
    endmodule

    // Instantiate 25 4-bit muxes
    genvar i;
    generate
        for (i = 0; i < 25; i = i + 1) begin : mux_array
            Mux4Bit mux (
                .a(a[i*4 +: 4]),
                .b(b[i*4 +: 4]),
                .sel(sel),
                .out(out[i*4 +: 4])
            );
        end
    endgenerate

endmodule