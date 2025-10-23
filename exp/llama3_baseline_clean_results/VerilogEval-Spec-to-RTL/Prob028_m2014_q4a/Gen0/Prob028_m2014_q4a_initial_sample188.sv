module TopModule(
    input d,
    input ena,
    output reg q
);

always @(*) begin
    if (ena) begin
        q <= d;
    end else begin
        q <= q; // This is a non-blocking assignment, but here it effectively does nothing.
    end
end

endmodule