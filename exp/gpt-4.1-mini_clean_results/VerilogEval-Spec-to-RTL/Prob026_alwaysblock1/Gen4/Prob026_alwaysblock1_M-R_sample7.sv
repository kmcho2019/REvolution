module TopModule(
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_alwaysblock
);

    // Directly assign AND operation to out_assign
    assign out_assign = a & b;

    // Use combinational always block to compute AND for out_alwaysblock
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule