module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

    always @(posedge clk) begin
        if (reset)
            out <= 8'b00000001;
        else begin
            // Shift left by 1; if MSB is set, wrap it around to LSB
            out <= {out[6:0], out[7]};
        end
    end

endmodule