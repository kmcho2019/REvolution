module TopModule #(
    parameter VECTOR_LENGTH = 32,
    parameter BYTE_SIZE = 8
) (
    input  [VECTOR_LENGTH-1:0] in,
    output [VECTOR_LENGTH-1:0] out
);

    genvar i;
    generate
        for (i = 0; i < VECTOR_LENGTH / BYTE_SIZE; i++) begin
            assign out[(i*BYTE_SIZE)+:BYTE_SIZE] = in[((VECTOR_LENGTH/BYTE_SIZE-1-i)*BYTE_SIZE)+:BYTE_SIZE];
        end
    endgenerate

endmodule