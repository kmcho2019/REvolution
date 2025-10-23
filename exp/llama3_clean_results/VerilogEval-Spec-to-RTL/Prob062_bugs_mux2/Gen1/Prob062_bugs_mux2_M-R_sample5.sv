module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    reg [7:0] out_reg;

    always @(*)
    begin
        if (sel)
            out_reg = b;
        else
            out_reg = a;
    end

    assign out = out_reg;

endmodule