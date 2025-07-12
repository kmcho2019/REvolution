module TopModule (
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_alwaysblock
);

    // Continuous assignment for direct AND gate implementation
    assign out_assign = a & b;

    // Combinational always block for AND gate implementation
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule