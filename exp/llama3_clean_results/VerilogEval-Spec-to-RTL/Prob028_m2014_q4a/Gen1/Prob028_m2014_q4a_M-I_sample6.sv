module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(d, ena) begin
    if (ena) begin
        q <= d;
    end else begin
        q <= q; // Explicitly retain the value of q when ena is low
    end
end

endmodule