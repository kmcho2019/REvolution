module TopModule(
    input  a,
    input  b,
    output reg out_alwaysblock,
    output out_assign
);

    wire and_result;

    // Combinational always block drives out_alwaysblock
    always @(*) begin
        out_alwaysblock = a & b;
    end

    // Assign driven from the same AND result through wire
    assign and_result = out_alwaysblock;
    assign out_assign = and_result;

endmodule