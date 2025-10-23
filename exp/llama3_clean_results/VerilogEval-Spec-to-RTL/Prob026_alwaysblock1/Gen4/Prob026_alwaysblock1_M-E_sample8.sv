module TopModule #(
    parameter USE_ASSIGN = 1
)(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

generate
    if (USE_ASSIGN) begin
        assign out_assign = a & b;
    end else begin
        assign out_assign = 1'bx;
    end
endgenerate

always @(*) begin
    out_alwaysblock = a & b;
end

endmodule