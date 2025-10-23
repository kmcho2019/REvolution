module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

reg msb_temp;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize with LSB set to 1
        out <= 8'b00000001;
    end
    else begin
        // Store MSB before shifting
        msb_temp <= out[7];
        
        // Manual circular shift left
        out[7] <= out[6];
        out[6] <= out[5];
        out[5] <= out[4];
        out[4] <= out[3];
        out[3] <= out[2];
        out[2] <= out[1];
        out[1] <= out[0];
        out[0] <= msb_temp;
    end
end

endmodule