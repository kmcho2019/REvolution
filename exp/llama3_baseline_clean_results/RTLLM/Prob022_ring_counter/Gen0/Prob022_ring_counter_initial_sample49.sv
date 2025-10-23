module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize to starting state when reset is high
            out <= 8'b0000_0001;
        end else begin
            // Shift the high bit to the next position on each clock pulse
            out <= {out[6:0], out[7]};
        end
    end

endmodule