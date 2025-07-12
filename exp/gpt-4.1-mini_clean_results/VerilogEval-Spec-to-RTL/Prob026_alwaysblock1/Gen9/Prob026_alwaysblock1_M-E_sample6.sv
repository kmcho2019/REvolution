module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Continuous assignment directly implements AND logic
    assign out_assign = a & b;

    // Combinational always block implements AND logic separately
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule