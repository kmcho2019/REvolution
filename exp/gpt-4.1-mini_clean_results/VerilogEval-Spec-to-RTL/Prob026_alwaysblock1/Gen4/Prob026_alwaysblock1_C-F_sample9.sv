module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Shared internal wire for AND operation
    wire and_val = a & b;

    // Continuous assignment for out_assign
    assign out_assign = and_val;

    // Combinational always block for out_alwaysblock
    always @(*) begin
        out_alwaysblock = and_val;
    end

endmodule