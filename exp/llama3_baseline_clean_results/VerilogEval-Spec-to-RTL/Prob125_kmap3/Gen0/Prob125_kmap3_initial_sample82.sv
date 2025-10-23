module TopModule(
    input a,
    input b,
    input c,
    input d,
    output reg out
);

always @(*) begin
    if (a) begin
        out = 1'b1;
    end else if (b) begin
        out = 1'b1;
    end else begin
        out = 1'b0;
    end
end

endmodule