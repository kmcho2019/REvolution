module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(d, ena) begin
    if (ena) begin
        q <= d;
    end else begin
        q <= q;
    end
end

endmodule