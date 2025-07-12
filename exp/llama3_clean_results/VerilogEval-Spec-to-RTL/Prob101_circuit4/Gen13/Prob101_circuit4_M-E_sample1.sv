module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

always_comb begin
    if (a) begin
        q = 1'b1;
    end else if (b || c) begin
        q = 1'b1;
    end else begin
        q = 1'b0;
    end
end

endmodule