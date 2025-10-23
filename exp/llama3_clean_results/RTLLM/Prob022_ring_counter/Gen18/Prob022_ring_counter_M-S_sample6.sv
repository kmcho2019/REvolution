module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 1'b1;
    end else begin
        out <= {out[6:0], out[7]};
    end
end

endmodule