module TopModule (
    input  logic [31:0] in,  
    output logic [31:0] out  
);
    localparam BYTE_WIDTH = 8;
    localparam NUM_BYTES = 4;

    assign out = {
        in[(NUM_BYTES-1)*BYTE_WIDTH - 1 : (NUM_BYTES-1)*BYTE_WIDTH - BYTE_WIDTH],
        in[(NUM_BYTES-2)*BYTE_WIDTH - 1 : (NUM_BYTES-2)*BYTE_WIDTH - BYTE_WIDTH],
        in[(NUM_BYTES-3)*BYTE_WIDTH - 1 : (NUM_BYTES-3)*BYTE_WIDTH - BYTE_WIDTH],
        in[(NUM_BYTES-4)*BYTE_WIDTH - 1 : (NUM_BYTES-4)*BYTE_WIDTH - BYTE_WIDTH]
    };
endmodule