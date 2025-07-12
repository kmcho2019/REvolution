module TopModule (
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_alwaysblock
);

    // Implement AND using assign statement
    assign out_assign = a & b;

    // Implement AND using combinational always block
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule