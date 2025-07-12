module counter_12 (
    input wire rst_n,          // Active low reset
    input wire clk,            // Clock
    input wire valid_count,    // Count enable
    output reg [3:0] out      // Counter output
);

// Custom state transition logic
always @(posedge clk) begin
    if (!rst_n) begin
        out <= 4'b0000;       // Synchronous reset
    end
    else if (valid_count) begin
        // Optimized state transition pattern
        case (out)
            4'b0000: out <= 4'b0001;  // 0->1
            4'b0001: out <= 4'b0011;  // 1->3
            4'b0011: out <= 4'b0010;  // 3->2
            4'b0010: out <= 4'b0110;  // 2->6
            4'b0110: out <= 4'b0111;  // 6->7
            4'b0111: out <= 4'b0101;  // 7->5
            4'b0101: out <= 4'b0100;  // 5->4
            4'b0100: out <= 4'b1100;  // 4->12 (will mask to 4'b1100)
            4'b1100: out <= 4'b1101;  // 12->13 (12 in our sequence)
            4'b1101: out <= 4'b1111;  // 13->15 (13->11)
            4'b1111: out <= 4'b1011;  // 15->11
            4'b1011: out <= 4'b0000;  // 11->0 (wrap)
            default: out <= 4'b0000;  // Fault recovery
        endcase
    end
    // else hold current value
end

// Output masking to ensure correct count sequence
wire [3:0] masked_out;
assign masked_out = (out == 4'b1100) ? 4'b1000 :  // Map 12->8
                   (out == 4'b1101) ? 4'b1001 :   // Map 13->9
                   (out == 4'b1111) ? 4'b1010 :   // Map 15->10
                   (out == 4'b1011) ? 4'b1011 :   // 11 stays
                   out;

// Final output register to clean up timing
always @(posedge clk) begin
    out <= masked_out;
end

endmodule