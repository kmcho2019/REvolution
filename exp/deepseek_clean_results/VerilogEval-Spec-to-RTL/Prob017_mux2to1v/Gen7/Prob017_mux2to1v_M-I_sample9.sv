module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Divide into 4 groups of 25 bits to reduce fanout
    wire [24:0] out_groups [0:3];
    
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : mux_group
            assign out_groups[i] = sel ? b[(i*25)+24:i*25] : a[(i*25)+24:i*25];
        end
    endgenerate
    
    // Combine outputs
    assign out = {out_groups[3], out_groups[2], out_groups[1], out_groups[0]};

endmodule