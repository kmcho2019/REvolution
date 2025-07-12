module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 1;
    end else begin
        out <= {out[0], out[7:1]}; // Shift right and wrap around
    end
end

endmodule