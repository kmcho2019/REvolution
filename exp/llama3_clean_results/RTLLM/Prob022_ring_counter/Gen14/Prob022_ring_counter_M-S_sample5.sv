module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] pos;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        pos <= 0;
        out <= 8'b0000_0001;
    end else begin
        pos <= (pos + 1) % 8;
        out <= (1 << pos);
    end
end

endmodule