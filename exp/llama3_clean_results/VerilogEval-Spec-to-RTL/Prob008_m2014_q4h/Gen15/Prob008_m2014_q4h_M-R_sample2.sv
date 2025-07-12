module TopModule(
    input  logic in,
    output logic out
);
    // Using an always block with a procedural assignment for combinational logic.
    // This is not the most efficient way for such a simple operation but demonstrates an alternative structure.
    always @(*) begin
        out = in;
    end
endmodule