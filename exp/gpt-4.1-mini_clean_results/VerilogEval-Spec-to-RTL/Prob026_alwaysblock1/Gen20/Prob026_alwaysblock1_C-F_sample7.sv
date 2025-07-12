module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Shared intermediate wire for the continuous assignment output
    wire and_result = a & b;

    // Continuous assignment for out_assign
    assign out_assign = and_result;

    // Combinational always block implementing AND directly on inputs
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule