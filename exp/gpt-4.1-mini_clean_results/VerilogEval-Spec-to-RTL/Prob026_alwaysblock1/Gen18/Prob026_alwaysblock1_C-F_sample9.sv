module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    wire and_wire = a & b;        // Single AND gate logic computed once

    assign out_assign = and_wire; // Continuous assignment output

    always @(*) begin
        out_alwaysblock = and_wire; // Combinational always block output driven by the same wire
    end

endmodule