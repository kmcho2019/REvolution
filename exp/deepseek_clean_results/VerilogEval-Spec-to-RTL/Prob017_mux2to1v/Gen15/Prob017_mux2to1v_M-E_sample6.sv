module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // First level: 25 4-bit muxes
    wire [24:0] stage1_sel;
    wire [99:0] stage1_out;
    
    genvar i;
    generate
        for (i = 0; i < 25; i = i + 1) begin : mux4bit
            assign stage1_out[i*4 +: 4] = sel ? b[i*4 +: 4] : a[i*4 +: 4];
            assign stage1_sel[i] = sel;  // Distribute select signal
        end
    endgenerate

    // Second level: 5 5-bit muxes (not used for data, just for select distribution)
    wire [4:0] stage2_sel;
    
    genvar j;
    generate
        for (j = 0; j < 5; j = j + 1) begin : mux5bit
            assign stage2_sel[j] = |stage1_sel[j*5 +: 5];  // OR reduction
        end
    endgenerate

    // Final level: 1 mux to select between groups (not used for data)
    wire final_sel = |stage2_sel;  // OR reduction

    // Output is directly from first stage muxes
    assign out = stage1_out;

endmodule