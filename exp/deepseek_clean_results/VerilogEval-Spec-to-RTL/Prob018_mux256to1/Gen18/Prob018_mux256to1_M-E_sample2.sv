module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);
    wire [255:0] shifted;

    // Hierarchical barrel shifter implementation
    // Each stage shifts by a power-of-2 amount
    wire [255:0] stage [0:7];
    
    // Initial stage
    assign stage[0] = sel[0] ? {in[254:0], in[255]} : in;
    
    // Subsequent stages
    generate
        for (genvar i = 1; i < 8; i = i + 1) begin : shift_stages
            assign stage[i] = sel[i] ? 
                {stage[i-1][255-(1<<i):0], stage[i-1][255:256-(1<<i)]} : 
                stage[i-1];
        end
    endgenerate
    
    // Final output is the LSB of the fully shifted value
    assign out = stage[7][0];
endmodule