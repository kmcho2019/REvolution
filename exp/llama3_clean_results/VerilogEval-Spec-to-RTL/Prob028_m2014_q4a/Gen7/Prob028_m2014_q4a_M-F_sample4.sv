module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(d or ena) begin
    if (ena) begin
        q <= d;
    end else begin
        q <= q; // This ensures q retains its value when ena is low
    end
end

endmodule