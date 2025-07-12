module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Continuous assignment implements AND for out_assign
    assign out_assign = a & b;

    // Combinational always block implements AND for out_alwaysblock
    always @(*) begin
        out_alwaysblock <= a & b;
    end

endmodule