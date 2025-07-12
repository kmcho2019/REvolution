module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(d, ena) begin
    if (ena) begin
        q <= d;
    end else begin
        q <= q; // This is not strictly necessary but makes it clear that q should hold its value
    end
end

endmodule