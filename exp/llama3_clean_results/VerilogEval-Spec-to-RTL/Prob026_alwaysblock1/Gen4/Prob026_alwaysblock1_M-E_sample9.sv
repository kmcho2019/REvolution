module TopModule(
    input  a,
    input  b,
    input  implementation_type, // 0: assign, 1: always block
    output reg out_assign,
    output reg out_alwaysblock
);

always @(*) begin
    if (implementation_type == 1'b0) begin
        out_assign = a & b;
        out_alwaysblock = 1'bx; // Don't care
    end else begin
        out_assign = 1'bx; // Don't care
        out_alwaysblock = a & b;
    end
end

assign out_assign = (implementation_type == 1'b0) ? (a & b) : 1'bx;

endmodule