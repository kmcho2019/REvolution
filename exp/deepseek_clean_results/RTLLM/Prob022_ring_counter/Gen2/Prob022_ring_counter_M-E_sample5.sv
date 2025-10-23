module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

parameter WIDTH = 8;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize with LSB set to 1 (one-hot)
        out <= 8'b00000001;
    end
    else begin
        // Circular left shift with one-hot maintenance
        out <= (out << 1) | (out[WIDTH-1] ? 1'b1 : 1'b0);
        
        // Alternative implementation option:
        // out <= {out[WIDTH-2:0], out[WIDTH-1]};
    end
end

endmodule