module TopModule(
    input  d,
    input  ena,
    output reg q
);
always @(*) begin
    if (ena) begin
        q <= d; // Non-blocking assignment for clearer latch behavior
    end else begin
        // Retain previous value when disabled; no action needed
    end
end

endmodule