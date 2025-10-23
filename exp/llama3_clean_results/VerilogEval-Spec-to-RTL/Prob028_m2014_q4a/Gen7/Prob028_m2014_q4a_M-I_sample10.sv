module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(d, ena) begin
    if (ena) begin
        q = d;
    end else begin
        // No action needed, q retains its value when ena is low
    end
end

endmodule