module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(d or ena) begin
    if (ena) begin
        q <= d;
    end else begin
        // No action, q remains the same
    end
end

endmodule