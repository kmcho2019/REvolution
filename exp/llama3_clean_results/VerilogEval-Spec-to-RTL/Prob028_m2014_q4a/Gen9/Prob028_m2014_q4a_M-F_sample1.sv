module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(d or ena) begin
    if (ena) begin
        q <= d; // When ena is high, q follows d
    end else begin
        q <= q; // Explicitly retain the previous value of q when ena is low
    end
end

endmodule