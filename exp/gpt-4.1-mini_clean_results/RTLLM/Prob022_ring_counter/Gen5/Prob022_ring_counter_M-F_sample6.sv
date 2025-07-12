module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg [7:0]  out
);

    integer i;
    always @(posedge clk) begin
        if (reset) begin
            // Reset: only LSB is high
            out[0] <= 1'b1;
            for (i = 1; i < 8; i = i + 1) begin
                out[i] <= 1'b0;
            end
        end else begin
            // Find which bit is set and move it to next bit
            for (i = 0; i < 8; i = i + 1) begin
                if (out[i]) begin
                    // Clear current bit
                    out[i] <= 1'b0;
                    // Set next bit, wrapping from 7 to 0
                    if (i == 7) begin
                        out[0] <= 1'b1;
                    end else begin
                        out[i+1] <= 1'b1;
                    end
                end else begin
                    // If bit not currently set and not next bit, keep 0
                    // But since we clear previous bit, no need to assign explicitly here.
                end
            end
        end
    end

endmodule