// Novel module to calculate the even parity bit for an 8-bit input byte using a shift register
module TopModule(
    input  clk,       // Clock signal
    input  rst_n,     // Active low reset
    input  [7:0] in,  // 8-bit input byte
    output parity     // 1-bit output for even parity
);

reg [7:0] shift_reg; // Shift register to hold the input byte
reg parity_reg;     // Register to hold the current parity state

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the shift register and parity state
        shift_reg <= 8'd0;
        parity_reg <= 1'b0;
    end else begin
        // Load the input byte into the shift register
        if (shift_reg == 8'd0) begin
            shift_reg <= in;
        end else begin
            // Shift the bits in the shift register and update the parity state
            shift_reg <= {shift_reg[6:0], 1'b0};
            parity_reg <= parity_reg ^ shift_reg[7];
        end
    end
end

// Output the final parity state after processing all bits
assign parity = parity_reg;

endmodule