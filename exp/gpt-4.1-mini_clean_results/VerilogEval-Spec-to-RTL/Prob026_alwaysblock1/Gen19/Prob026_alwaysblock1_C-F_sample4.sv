module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    wire and_result = a & b;        // Single AND gate computation

    assign out_assign = and_result; // Continuous assignment output

    always @(*) begin
        out_alwaysblock = and_result; // Combinational always block output driven by the wire
    end

endmodule