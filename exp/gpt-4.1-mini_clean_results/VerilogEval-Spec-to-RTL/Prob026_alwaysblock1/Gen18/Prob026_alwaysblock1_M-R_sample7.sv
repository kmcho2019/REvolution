module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    wire and_result;

    // Compute AND on intermediate wire
    assign and_result = a & b;

    // Drive out_assign directly from intermediate wire
    assign out_assign = and_result;

    // Combinational always block output driven by intermediate wire
    always @(*) begin
        out_alwaysblock = and_result;
    end

endmodule