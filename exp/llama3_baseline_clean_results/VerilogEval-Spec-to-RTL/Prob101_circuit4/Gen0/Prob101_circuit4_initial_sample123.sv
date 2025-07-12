module TopModule(
    input a,
    input b,
    input c,
    input d,
    output reg q
);

always @(*) begin
    if (b == 1 || c == 1) begin
        q = 1'b1;
    end else if (a == 1 && (c == 1 || d == 1)) begin
        q = 1'b1;
    end else begin
        q = 1'b0;
    end
end

endmodule