module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

assign out_assign = (a == 1'b1) && (b == 1'b1)? 1'b1 : 1'b0;

always @(*) begin
    if (a && b) begin
        out_alwaysblock = 1'b1;
    end else begin
        out_alwaysblock = 1'b0;
    end
end

endmodule