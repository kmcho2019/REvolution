module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Combined assignments for better optimization
    always @(*) begin
        // out_both: bits 2:0 only (in[3] has no left neighbor)
        out_both = {1'b0, in[2:0] & in[3:1]};
        
        // out_any: bits 3:1 only (in[0] has no right neighbor)
        out_any = {in[3:1] | in[2:0], 1'b0};
        
        // out_different: circular XOR (all bits)
        out_different = in ^ {in[0], in[3:1]};
    end

endmodule