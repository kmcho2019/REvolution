module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Internal wire for continuous assign implementation
    wire and_wire;
    assign and_wire = a & b;

    // Assign output driven by internal wire (continuous assignment)
    assign out_assign = and_wire;

    // Always block implements AND operation explicitly (procedural style)
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule