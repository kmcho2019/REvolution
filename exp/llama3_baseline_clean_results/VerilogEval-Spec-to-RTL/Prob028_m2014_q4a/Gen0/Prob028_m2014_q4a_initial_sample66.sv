module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(*) begin
    if (ena) begin
        q <= d;
    end else begin
        q <= q; // or simply do nothing, as q will hold its value by default in a latch
    end
end

endmodule