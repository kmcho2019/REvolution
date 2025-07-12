module counter_12 (
    input wire rst_n,          // Active low reset
    input wire clk,            // Clock
    input wire valid_count,    // Count enable
    output wire [3:0] out     // Counter output
);

reg [11:0] shift_reg;         // One-hot shift register

// Shift register with feedback
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 12'b0000_0000_0001;  // Initialize to count 0
    end
    else if (valid_count) begin
        // Circular shift with wrap-around
        shift_reg <= {shift_reg[10:0], shift_reg[11]};
    end
end

// One-hot to binary encoder
assign out = 
    (shift_reg[0])  ? 4'b0000 :
    (shift_reg[1])  ? 4'b0001 :
    (shift_reg[2])  ? 4'b0010 :
    (shift_reg[3])  ? 4'b0011 :
    (shift_reg[4])  ? 4'b0100 :
    (shift_reg[5])  ? 4'b0101 :
    (shift_reg[6])  ? 4'b0110 :
    (shift_reg[7])  ? 4'b0111 :
    (shift_reg[8])  ? 4'b1000 :
    (shift_reg[9])  ? 4'b1001 :
    (shift_reg[10]) ? 4'b1010 :
    (shift_reg[11]) ? 4'b1011 :
    4'b0000;  // Default case (should never occur)

endmodule