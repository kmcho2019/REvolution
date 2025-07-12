module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    wire and_result;
    assign and_result = a & b;

    // Continuous assignment drives one output directly
    assign out_assign = and_result;

    // Combinational always block drives other output using blocking assignment
    always @(*) begin
        out_alwaysblock = and_result;
    end

endmodule