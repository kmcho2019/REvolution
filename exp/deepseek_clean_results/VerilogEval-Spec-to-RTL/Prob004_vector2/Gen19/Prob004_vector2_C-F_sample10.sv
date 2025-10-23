module TopModule #(parameter WIDTH = 32) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);
    localparam BYTES = WIDTH/8;
    
    genvar i;
    generate
        for (i = 0; i < BYTES; i = i + 1) begin : byte_reverse
            assign out[(i*8)+:8] = in[((BYTES-1-i)*8)+:8];
        end
    endgenerate
endmodule