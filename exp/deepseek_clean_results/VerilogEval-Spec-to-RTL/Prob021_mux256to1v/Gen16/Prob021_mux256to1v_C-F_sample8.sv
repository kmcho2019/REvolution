module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // First stage: 16 groups of 16 4-bit inputs
    wire [3:0] stage1_out [0:15];
    
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : first_stage
            // Directly compute each group's output without intermediate wires
            assign stage1_out[i] = in[(i * 64) + (sel[3:0] * 4) +: 4];
        end
    endgenerate

    // Second stage: Final 16:1 mux using upper 4 bits of sel
    assign out = stage1_out[sel[7:4]];

endmodule