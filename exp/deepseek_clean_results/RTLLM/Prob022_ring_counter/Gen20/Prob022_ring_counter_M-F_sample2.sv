module ring_counter (
    input wire clk,
    input wire reset,
    output reg [7:0] out
);

always @(posedge clk) begin
    if (reset) begin
        out <= 8'b00000001;  // Initialize with LSB set
    end else begin
        // Manual circular shift implementation
        out[7]   <= out[6];
        out[6]   <= out[5];
        out[5]   <= out[4];
        out[4]   <= out[3];
        out[3]   <= out[2];
        out[2]   <= out[1];
        out[1]   <= out[0];
        out[0]   <= out[7];
    end
end

endmodule