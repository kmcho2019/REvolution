module counter_12 (
    input wire rst_n,          // Active low reset
    input wire clk,            // Clock
    input wire valid_count,    // Count enable
    output reg [3:0] out      // Counter output
);

always @(posedge clk) begin
    if (!rst_n) begin
        out <= 4'b0000;       // Synchronous reset
    end
    else if (valid_count) begin
        // Efficient terminal count detection (1011 pattern)
        if (out[3] & out[1] & out[0]) begin
            out <= 4'b0000;   // Explicit wrap at 11
        end else begin
            out <= out + 1;   // Normal increment
        end
    end
end

endmodule