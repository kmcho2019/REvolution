module counter_12 (
    input wire rst_n,          // Active low reset
    input wire clk,            // Clock
    input wire valid_count,    // Count enable
    output reg [3:0] out      // Counter output
);

// Circular shift register implementation
always @(posedge clk) begin
    if (!rst_n) begin
        // Initialize with single '1' at LSB (represents count 0)
        out <= 4'b0001;
    end
    else if (valid_count) begin
        // Rotate right with wrap-around
        out <= {out[0], out[3:1]};
    end
    // Else maintain current value
end

// Convert one-hot encoding to binary count
// Note: This could be removed if one-hot output is acceptable
wire [3:0] binary_out;
assign binary_out = 
    (out == 4'b0001) ? 4'b0000 :  // 0
    (out == 4'b0010) ? 4'b0001 :   // 1
    (out == 4'b0100) ? 4'b0010 :   // 2
    (out == 4'b1000) ? 4'b0011 :   // 3
    (out == 4'b0001) ? 4'b0100 :   // 4 (after wrap-around)
    (out == 4'b0010) ? 4'b0101 :   // 5
    (out == 4'b0100) ? 4'b0110 :   // 6
    (out == 4'b1000) ? 4'b0111 :   // 7
    (out == 4'b0001) ? 4'b1000 :   // 8
    (out == 4'b0010) ? 4'b1001 :   // 9
    (out == 4'b0100) ? 4'b1010 :   // 10
    (out == 4'b1000) ? 4'b1011 :   // 11
    4'b0000;                       // Default

// Optional: Choose between one-hot or binary output
assign out = binary_out;  // Comment out to use one-hot output directly

endmodule