module TopModule #(
    parameter IN_WIDTH  = 8,
    parameter OUT_WIDTH = 32
)(
    input  wire [IN_WIDTH-1:0] in,
    output wire [OUT_WIDTH-1:0] out
);
    // Sign-extend the input by replicating the sign bit (MSB) of the input 
    // to the left (OUT_WIDTH - IN_WIDTH) times, followed by the original input bits.
    // This preserves the signed value when widening from IN_WIDTH bits to OUT_WIDTH bits.
    assign out = {{(OUT_WIDTH - IN_WIDTH){in[IN_WIDTH-1]}}, in};
endmodule