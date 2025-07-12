module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Combinational always block computing AND of inputs
    always @(*) begin
        out_alwaysblock = a & b;
    end

    // Continuous assignment driven directly from the always block reg output
    assign out_assign = out_alwaysblock;

endmodule