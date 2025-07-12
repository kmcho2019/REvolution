module TopModule(
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_alwaysblock
);

    wire and_ab;

    // Single AND operation computed once
    assign and_ab = a & b;

    // Drive out_assign continuously from intermediate wire
    assign out_assign = and_ab;

    // Use combinational always block to drive out_alwaysblock from the same wire
    always @(*) begin
        out_alwaysblock = and_ab;
    end

endmodule