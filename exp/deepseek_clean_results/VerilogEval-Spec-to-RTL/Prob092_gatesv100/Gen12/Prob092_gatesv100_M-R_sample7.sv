module TopModule (
    input [99:0] in,
    output reg [99:0] out_both,
    output reg [99:0] out_any,
    output reg [99:0] out_different
);

    genvar i;
    
    // out_both generation
    generate
        for (i = 0; i < 100; i = i + 1) begin : both_gen
            always @(*) begin
                if (i == 99)
                    out_both[i] = 1'b0;
                else
                    out_both[i] = in[i] & in[i+1];
            end
        end
    endgenerate
    
    // out_any generation
    generate
        for (i = 0; i < 100; i = i + 1) begin : any_gen
            always @(*) begin
                if (i == 0)
                    out_any[i] = 1'b0;
                else
                    out_any[i] = in[i] | in[i-1];
            end
        end
    endgenerate
    
    // out_different generation with wrap-around
    generate
        for (i = 0; i < 100; i = i + 1) begin : diff_gen
            always @(*) begin
                if (i == 99)
                    out_different[i] = in[i] ^ in[0];
                else
                    out_different[i] = in[i] ^ in[i+1];
            end
        end
    endgenerate

endmodule