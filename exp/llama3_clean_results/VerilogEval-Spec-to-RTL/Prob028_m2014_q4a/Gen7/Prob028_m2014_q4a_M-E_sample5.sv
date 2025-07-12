module TopModule(
    input  d,
    input  ena,
    output reg q
);
always @(*) begin
    if (ena) begin
        q = d; // Capture input data when enabled
    end else begin
        // Retain previous value when disabled
    end
end

endmodule