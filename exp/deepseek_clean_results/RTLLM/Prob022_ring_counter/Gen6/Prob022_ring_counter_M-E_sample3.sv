module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

parameter WIDTH = 8;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b00000001;  // Initialize with LSB set
    end
    else begin
        // Circular shift left with wrap-around
        out <= {out[WIDTH-2:0], out[WIDTH-1]};
    end
end

endmodule