module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Continuous assign for one output
    assign out_assign = a & b;

    // Combinational always block for the other output, no intermediate reg needed
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule