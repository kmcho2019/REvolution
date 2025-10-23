module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    ///////////////////////////////////////////////
    // Implementation using continuous assignment
    // - Simple, direct wiring style
    // - Most efficient for basic combinational logic
    assign out_assign = a & b;

    ///////////////////////////////////////////////
    // Implementation using always block
    // - More flexible for complex combinational logic
    // - Demonstrates procedural assignment style
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule