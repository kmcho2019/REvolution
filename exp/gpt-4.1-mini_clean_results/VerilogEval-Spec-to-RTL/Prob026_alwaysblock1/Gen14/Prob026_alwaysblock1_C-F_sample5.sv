module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Internal wire computes AND once
    wire and_result = a & b;

    // Continuous assign output
    assign out_assign = and_result;

    // Combinational always block output
    always @(*) begin
        out_alwaysblock = and_result;
    end

endmodule