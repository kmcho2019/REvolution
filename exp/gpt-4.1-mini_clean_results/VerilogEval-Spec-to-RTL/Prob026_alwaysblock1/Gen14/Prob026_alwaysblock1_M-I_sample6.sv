module TopModule (
    input  wire a,
    input  wire b,
    output wire out_assign,
    output logic out_alwaysblock
);

    // Continuous assignment implementing AND
    assign out_assign = a & b;

    // Combinational always block implementing AND
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule