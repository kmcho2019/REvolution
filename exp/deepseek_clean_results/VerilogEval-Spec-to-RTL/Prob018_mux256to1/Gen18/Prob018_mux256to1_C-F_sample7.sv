module OptimizedMux256to1 (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // First level: Split into 4 groups of 64
    wire [3:0] level1_out;
    generate
        for (genvar i = 0; i < 4; i = i + 1) begin : level1
            // Second level: Split each 64 into 4 groups of 16
            wire [3:0] level2_out;
            for (genvar j = 0; j < 4; j = j + 1) begin : level2
                // Third level: Split each 16 into 4 groups of 4
                wire [3:0] level3_out;
                for (genvar k = 0; k < 4; k = k + 1) begin : level3
                    // Base case: 4-to-1 mux
                    assign level3_out[k] = in[
                        (i*64) + (j*16) + (k*4) + sel[1:0]
                    ];
                end
                // Select from level3 using sel[3:2]
                assign level2_out[j] = level3_out[sel[3:2]];
            end
            // Select from level2 using sel[5:4]
            assign level1_out[i] = level2_out[sel[5:4]];
        end
    endgenerate
    
    // Final selection using top 2 bits (sel[7:6])
    assign out = level1_out[sel[7:6]];

endmodule

module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    OptimizedMux256to1 mux (
        .in(in),
        .sel(sel),
        .out(out)
    );

endmodule