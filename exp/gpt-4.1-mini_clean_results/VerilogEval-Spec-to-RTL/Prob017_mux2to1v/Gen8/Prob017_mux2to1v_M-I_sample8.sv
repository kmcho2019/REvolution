module Mux2to1_Nbit #(
    parameter WIDTH = 1
) (
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire             sel,
    output wire [WIDTH-1:0] out
);
    assign out = sel ? b : a;
endmodule

module TopModule (
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Instantiate 10 blocks of 10-bit muxes
    genvar i;
    generate
        for (i=0; i<10; i=i+1) begin : mux_blocks
            Mux2to1_Nbit #(.WIDTH(10)) u_mux (
                .a   (a[i*10 +: 10]),
                .b   (b[i*10 +: 10]),
                .sel (sel),
                .out (out[i*10 +: 10])
            );
        end
    endgenerate
endmodule