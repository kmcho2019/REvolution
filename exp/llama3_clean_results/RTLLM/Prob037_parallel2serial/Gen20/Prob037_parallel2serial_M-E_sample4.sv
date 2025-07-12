module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

// Internal shift register
reg [3:0] shift_reg;

// Internal counter
reg [1:0] cnt;

// Sequential logic for counter and shift register
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset counter and shift register on reset
        cnt <= 2'b00;
        shift_reg <= 4'b0000;
    end else if (cnt == 2'b11) begin
        // If counter has reached 3, reset counter and shift register
        cnt <= 2'b00;
        shift_reg <= 4'b0000;
    end else begin
        // Otherwise, increment counter and shift shift register
        cnt <= cnt + 1'b1;
        shift_reg <= {shift_reg[2:0], 1'b0};
        if (cnt == 2'b00) begin
            shift_reg <= d;
        end
    end
end

// Assign valid signal based on counter value
assign valid_out = (cnt != 2'b00);

// Assign bit from shift register as serial output
assign dout = shift_reg[3];

endmodule