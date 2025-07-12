module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

// Internal registers
reg [1:0] cnt;                   // Counter to keep track of the bits
reg         valid_out;            // Valid signal
reg         dout;                 // Serial output

// Combined sequential logic for counter and output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset all registers on reset
        cnt <= 2'b00;
        valid_out <= 1'b0;
        dout <= 1'b0;
    end else if (cnt == 2'b11) begin
        // If counter has reached 3, reset counter and update output
        cnt <= 2'b00;
        valid_out <= 1'b1;
        dout <= d[3];
    end else begin
        // Otherwise, increment counter and update output
        cnt <= cnt + 1'b1;
        valid_out <= (cnt == 2'b00) ? 1'b1 : 1'b0;
        case (cnt)
            2'b00: dout <= d[3];
            2'b01: dout <= d[2];
            2'b10: dout <= d[1];
            2'b11: dout <= d[0];
        endcase
    end
end

endmodule