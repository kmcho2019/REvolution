module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Single intermediate wire to share the AND logic
    wire and_result = a & b;

    // Continuous assignment output
    assign out_assign = and_result;

    // Combinational always block output driven from the same wire
    always @(*) begin
        out_alwaysblock = and_result;
    end

endmodule