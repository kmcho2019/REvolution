module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

// Shift direction is implicit in the pattern:
// - If LSB is set (xxxx1), we're shifting left
// - If MSB is set (1xxxx), we're shifting right

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wave <= 5'b00001;  // Start pattern (shift left)
    end
    else begin
        casez (wave)
            5'b1????: wave <= {1'b0, wave[4:1]};  // Shift right
            5'b00001: wave <= 5'b00010;           // Special case for clean transition
            default:  wave <= {wave[3:0], 1'b0};   // Shift left
        endcase
    end
end

endmodule