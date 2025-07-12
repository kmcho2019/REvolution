module TopModule (
    input [3:0] in,
    output reg [3:0] out_both,
    output reg [3:0] out_any,
    output reg [3:0] out_different
);

    always_comb begin
        // out_both: check current bit and left neighbor
        out_both = {1'b0, in[2:0] & in[3:1]};
        
        // out_any: check current bit or right neighbor
        out_any = {in[3:1] | in[2:0], 1'b0};
        
        // out_different: XOR with left neighbor (wrap-around)
        out_different = in ^ {in[0], in[3:1]};
    end

endmodule