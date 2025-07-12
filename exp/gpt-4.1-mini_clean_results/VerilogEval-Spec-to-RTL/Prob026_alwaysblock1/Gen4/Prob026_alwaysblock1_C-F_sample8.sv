module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Shared intermediate wire computes the AND once
    wire and_val = a & b;

    // Continuous assign for out_assign
    assign out_assign = and_val;

    // Combinational always block for out_alwaysblock using the same wire
    always @(*) begin
        out_alwaysblock = and_val;
    end

endmodule