module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 8'b00000001;
        end else begin
            // Rotate left by 1 bit: capture MSB before shift
            // Then shift left and assign MSB to LSB
            out <= {out[6:0], out[7]};
        end
    end

endmodule