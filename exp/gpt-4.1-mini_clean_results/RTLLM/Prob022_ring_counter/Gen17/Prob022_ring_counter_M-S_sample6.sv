module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 8'b00000001;
        end else begin
            // Shift left by one; if MSB was 1 before shift, wrap around by setting LSB
            out <= {out[6:0], out[7]};
        end
    end

endmodule