module TopModule (
    input [3:0] in,
    output reg [3:0] out_both,
    output reg [3:0] out_any,
    output reg [3:0] out_different
);

    always @(*) begin
        // out_both: bits 2:0 are AND of current and left neighbor
        out_both = 4'b0;
        out_both[2:0] = in[2:0] & in[3:1];
        
        // out_any: bits 3:1 are OR of current and right neighbor
        out_any = 4'b0;
        out_any[3:1] = in[3:1] | in[2:0];
        
        // out_different: XOR with left neighbor (circular)
        out_different = in ^ {in[0], in[3:1]};
    end

endmodule