module TopModule(
    input a,
    input b,
    input c,
    input d,
    output reg q
);

always @(*) begin
    if (b || c) begin
        q = 1'b1;
    end else if (a && (b || c)) begin
        q = 1'b1;
    end else begin
        q = 1'b0;
    end
end

endmodule