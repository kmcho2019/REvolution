module counter_12 (
    input wire rst_n,         // Active low reset
    input wire clk,           // Clock signal
    input wire valid_count,   // Enable counting
    output wire [3:0] out     // 4-bit counter output
);

reg [3:0] shift_reg;
wire wrap_around;

// Shift register with parallel load
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 4'b0001;  // Initialize with LSB set
    end else if (valid_count) begin
        if (wrap_around) begin
            shift_reg <= 4'b0001;  // Reset pattern
        end else begin
            shift_reg <= {shift_reg[2:0], shift_reg[3]};  // Rotate left
        end
    end
end

// Detect when '1' has reached the MSB
assign wrap_around = (shift_reg == 4'b1000);

// Priority encoder to convert shift pattern to binary count
assign out = 
    (shift_reg == 4'b0001) ? 4'd0 :
    (shift_reg == 4'b0010) ? 4'd1 :
    (shift_reg == 4'b0100) ? 4'd2 :
    (shift_reg == 4'b1000) ? 4'd3 :
    (shift_reg == 4'b0001) ? 4'd4 :  // After wrap-around
    (shift_reg == 4'b0010) ? 4'd5 :
    (shift_reg == 4'b0100) ? 4'd6 :
    (shift_reg == 4'b1000) ? 4'd7 :
    (shift_reg == 4'b0001) ? 4'd8 :  // After wrap-around
    (shift_reg == 4'b0010) ? 4'd9 :
    (shift_reg == 4'b0100) ? 4'd10 :
    (shift_reg == 4'b1000) ? 4'd11 :
    4'd0;  // Default case (should never occur)

endmodule