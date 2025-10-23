module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // First level: 16 16-to-1 muxes
    wire [3:0] first_level [0:15];
    
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : first_level_muxes
            // Each first level mux selects among 16 4-bit groups (total 64 bits per mux)
            assign first_level[i] = in[(i*64) + (sel[3:0]*4) +: 4];
        end
    endgenerate

    // Second level: 16-to-1 mux
    assign out = first_level[sel[7:4]];

endmodule