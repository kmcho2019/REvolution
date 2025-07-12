module TopModule #(
    parameter implementation = 0
) (
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

wire and_assign;

assign and_assign = a & b;
assign out_assign = and_assign;

always @(*) begin
    if (implementation == 0) begin
        out_alwaysblock = and_assign;
    end else begin
        out_alwaysblock = a & b;
    end
end

endmodule