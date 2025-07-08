module TopModule(
    input a,
    input b,
    output out_assign,
    output reg out_alwaysblock
);

    // Continuous assignment implementing AND gate
    assign out_assign = a & b;

    // Combinational always block implementing AND gate
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule