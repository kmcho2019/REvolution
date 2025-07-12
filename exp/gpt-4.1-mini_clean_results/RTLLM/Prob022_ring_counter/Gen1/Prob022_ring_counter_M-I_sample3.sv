module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg [7:0]  out
);

reg [2:0] pos;  // position of the single '1' bit

always @(posedge clk) begin
    if (reset) begin
        pos <= 3'd0;
        out <= 8'b00000001;
    end else begin
        // increment position modulo 8
        pos <= pos + 3'd1;
        out <= 8'b00000001 << pos;
    end
end

endmodule