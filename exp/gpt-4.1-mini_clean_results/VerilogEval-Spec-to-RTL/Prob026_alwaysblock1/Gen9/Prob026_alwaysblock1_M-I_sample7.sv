module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // out_assign driven directly from AND of inputs
    assign out_assign = a & b;

    // out_alwaysblock assigned inside combinational always block using AND expression directly
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule