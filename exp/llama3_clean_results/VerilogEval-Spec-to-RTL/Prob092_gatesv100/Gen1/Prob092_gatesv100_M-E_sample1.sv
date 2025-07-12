module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    reg [99:0] out_both_reg;
    reg [99:0] out_any_reg;
    reg [99:0] out_different_reg;

    always @(*)
    begin
        // Calculate out_both
        out_both_reg = in & ({in[0], in[99:1]});

        // Calculate out_any
        out_any_reg = in | ({in[98:0], 1'b0});

        // Calculate out_different
        out_different_reg = ~(in ^ ({in[0], in[99:1]}));

        out_both = out_both_reg;
        out_any = out_any_reg;
        out_different = out_different_reg;
    end

endmodule