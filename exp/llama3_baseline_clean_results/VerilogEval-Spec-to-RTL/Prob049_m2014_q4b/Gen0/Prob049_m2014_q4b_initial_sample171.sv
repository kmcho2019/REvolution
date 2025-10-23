module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

always @(posedge ar or posedge clk) begin
    if (ar) begin
        q <= 1'b0; // Reset q to 0 when ar is high
    end else if (posedge clk) begin
        q <= d; // Capture d on the rising edge of clk when ar is low
    end
end

endmodule