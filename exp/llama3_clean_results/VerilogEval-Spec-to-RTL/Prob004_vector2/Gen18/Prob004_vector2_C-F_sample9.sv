module TopModule (
    input  logic [31:0] in,  
    output logic [31:0] out  
);

    localparam NUM_BYTES = 4;
    localparam BYTE_WIDTH = 8;

    genvar i;
    generate
        for (i = 0; i < NUM_BYTES; i++) begin
            assign out[(i * BYTE_WIDTH) +: BYTE_WIDTH] = in[(NUM_BYTES - 1 - i) * BYTE_WIDTH +: BYTE_WIDTH];
        end
    endgenerate

endmodule