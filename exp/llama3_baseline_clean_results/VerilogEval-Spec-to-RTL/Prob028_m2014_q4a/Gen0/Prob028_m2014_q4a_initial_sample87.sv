module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(*) begin
    if (ena) begin
        q <= d;
    end else begin
        q <= q; // or simply do nothing, to keep the current value
    end
end

endmodule