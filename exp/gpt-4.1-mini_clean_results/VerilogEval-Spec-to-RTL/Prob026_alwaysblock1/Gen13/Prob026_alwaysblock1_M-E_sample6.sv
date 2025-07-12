module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    wire and_result;
    assign and_result = a & b;         // Internal combinational logic wire

    assign out_assign = and_result;    // Directly driven by the wire

    always @(*) begin
        out_alwaysblock = and_result;  // Assigned from wire in combinational always block
    end

endmodule