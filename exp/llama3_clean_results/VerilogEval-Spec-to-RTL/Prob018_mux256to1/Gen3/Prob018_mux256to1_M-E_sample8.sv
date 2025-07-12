module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);
    wire [15:0] chunk_out;

    // First stage: select one of the 16 chunks
    mux16to1 #(.WIDTH(16)) u_mux16to1(
       .in({in[255:240], in[239:224], in[223:208], in[207:192],
             in[191:176], in[175:160], in[159:144], in[143:128],
             in[127:112], in[111:96], in[95:80], in[79:64],
             in[63:48], in[47:32], in[31:16], in[15:0]}),
       .sel(sel[7:4]),
       .out(chunk_out)
    );

    // Second stage: select one bit from the chosen chunk
    mux16to1 #(.WIDTH(1)) u_mux16to1_bit(
       .in(chunk_out),
       .sel(sel[3:0]),
       .out(out)
    );
endmodule

module mux16to1 #(
    parameter WIDTH = 1
)(
    input [15*WIDTH-1:0] in,
    input [3:0] sel,
    output [WIDTH-1:0] out
);
    assign out = in[sel*WIDTH +: WIDTH];
endmodule