module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // First level: 64 4-to-1 muxes (each selecting from 4 4-bit groups)
    wire [3:0] first_level [0:63];
    
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : first_level_muxes
            assign first_level[i] = in[(i*16) + (sel[1:0]*4) +: 4];
        end
    endgenerate

    // Second level: 16 4-to-1 muxes
    wire [3:0] second_level [0:15];
    
    genvar j;
    generate
        for (j = 0; j < 16; j = j + 1) begin : second_level_muxes
            assign second_level[j] = first_level[(j*4) + sel[3:2]];
        end
    endgenerate

    // Third level: 4 4-to-1 muxes
    wire [3:0] third_level [0:3];
    
    genvar k;
    generate
        for (k = 0; k < 4; k = k + 1) begin : third_level_muxes
            assign third_level[k] = second_level[(k*4) + sel[5:4]];
        end
    endgenerate

    // Final level: 1 4-to-1 mux
    assign out = third_level[sel[7:6]];

endmodule