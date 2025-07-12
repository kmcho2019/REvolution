module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Shared intermediate wire for AND operation
    wire and_wire = a & b;

    // Continuous assignment
    assign out_assign = and_wire;

    // Combinational always block with blocking assignment
    always @(*) begin
        out_alwaysblock = and_wire;
    end

endmodule