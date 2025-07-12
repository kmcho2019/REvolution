module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(ena or d) begin
    if (ena) begin
        q <= d;
    end else begin
        q <= q; // Latch the current value when ena is 0
    end
end

endmodule