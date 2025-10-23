module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(*) begin
    if (ena) begin
        q = d;
    end else begin
        // do nothing, q will keep its current value
    end
end

endmodule