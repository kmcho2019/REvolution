module ring_counter #(
    parameter WIDTH = 8
) (
    input clk,
    input reset,
    output reg [WIDTH-1:0] out
);

always @(posedge clk) begin
    if (reset) begin
        out <= {1'b1, {(WIDTH-1){1'b0}}};  // Initialize with LSB set
    end
    else begin
        out <= {out[WIDTH-2:0], out[WIDTH-1]};  // Rotate left
    end
end

endmodule