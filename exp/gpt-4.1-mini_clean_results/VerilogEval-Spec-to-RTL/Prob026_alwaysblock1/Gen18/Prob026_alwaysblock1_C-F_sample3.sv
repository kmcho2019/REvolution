module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Shared intermediate wire for the AND logic
    wire and_result = a & b;

    // Continuous assignment for out_assign
    assign out_assign = and_result;

    // Combinational always block for out_alwaysblock
    always @(*) begin
        out_alwaysblock = and_result;
    end

endmodule