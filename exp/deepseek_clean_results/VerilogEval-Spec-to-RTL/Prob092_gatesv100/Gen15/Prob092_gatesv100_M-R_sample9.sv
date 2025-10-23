module TopModule (
    input [99:0] in,
    output reg [99:0] out_both,
    output reg [99:0] out_any,
    output reg [99:0] out_different
);

    always @(*) begin
        // out_both calculation
        out_both[99] = 1'b0;
        out_both[98:0] = in[98:0] & in[99:1];
        
        // out_any calculation
        out_any[0] = 1'b0;
        out_any[99:1] = in[99:1] | in[98:0];
        
        // out_different calculation
        out_different = in ^ {in[0], in[99:1]};
    end

endmodule