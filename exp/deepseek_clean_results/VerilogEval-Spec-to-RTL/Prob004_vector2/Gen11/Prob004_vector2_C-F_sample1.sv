module ByteReverser #(parameter WIDTH = 32, BYTE_SIZE = 8) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);
    // Calculate number of bytes (must be power of 2)
    localparam NUM_BYTES = WIDTH / BYTE_SIZE;
    
    generate
        if (NUM_BYTES == 4) begin: reverse_32bit
            // Optimal direct concatenation for 32-bit case
            assign out = {in[7:0],   in[15:8], 
                          in[23:16], in[31:24]};
        end
        else begin: reverse_generic
            // Generic implementation for other widths
            genvar i;
            for (i = 0; i < NUM_BYTES; i = i + 1) begin: byte_loop
                assign out[(i+1)*BYTE_SIZE-1:i*BYTE_SIZE] = 
                       in[(NUM_BYTES-i)*BYTE_SIZE-1:(NUM_BYTES-i-1)*BYTE_SIZE];
            end
        end
    endgenerate
endmodule

module TopModule (
    input  [31:0] in,
    output [31:0] out
);
    // Instantiate the parameterized reverser with 32-bit width
    ByteReverser #(.WIDTH(32)) reverser (
        .in(in),
        .out(out)
    );
endmodule