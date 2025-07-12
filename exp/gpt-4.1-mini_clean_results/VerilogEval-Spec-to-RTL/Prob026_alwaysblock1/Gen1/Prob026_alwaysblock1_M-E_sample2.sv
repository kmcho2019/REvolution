module TopModule(
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_alwaysblock
);

    wire and_result;

    // Compute AND using an assign statement for intermediate wire
    assign and_result = a & b;

    // Drive out_assign directly from the wire
    assign out_assign = and_result;

    // Use combinational always block to assign out_alwaysblock from the wire
    always @(*) begin
        out_alwaysblock = and_result;
    end

endmodule