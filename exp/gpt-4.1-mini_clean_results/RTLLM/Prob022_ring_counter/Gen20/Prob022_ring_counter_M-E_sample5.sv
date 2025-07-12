module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 8'b00000001;
        end else begin
            // Check if MSB is 1 before shifting
            if (out[7]) begin
                // Shift left by 1 and wrap around by setting LSB to 1
                out <= (out << 1) | 8'b00000001;
            end else begin
                // Just shift left by 1
                out <= out << 1;
            end
        end
    end

endmodule