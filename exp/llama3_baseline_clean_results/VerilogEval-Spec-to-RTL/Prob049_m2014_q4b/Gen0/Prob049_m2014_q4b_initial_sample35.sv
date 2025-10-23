module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0; // Reset to 0 when ar is high
    end else begin
        q <= d; // Capture d at the positive edge of clk
    end
end

endmodule