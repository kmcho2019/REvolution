module TopModule(
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    wire and_result;

    // Continuous assignment of intermediate wire
    assign and_result = a & b;

    // Assign output out_assign directly from the intermediate wire
    assign out_assign = and_result;

    // Combinational always block using the intermediate wire
    always @(*) begin
        out_alwaysblock = and_result;
    end

endmodule