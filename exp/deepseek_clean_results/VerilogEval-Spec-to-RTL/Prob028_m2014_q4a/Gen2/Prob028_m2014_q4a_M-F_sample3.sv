module TopModule (
    input d,
    input ena,
    output reg q
);

always @(*) begin
    if (ena) begin
        q <= d;  // Transparent when enabled
    end
    else begin
        q <= q;  // Explicit hold when not enabled
    end
end

endmodule