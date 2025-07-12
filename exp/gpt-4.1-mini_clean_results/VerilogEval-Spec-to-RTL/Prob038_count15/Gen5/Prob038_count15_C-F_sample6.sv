module TopModule (
    input  clk,
    input  reset,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0000;
        end else begin
            // Enable signals for toggling bits
            // Bit 0 always toggles
            // Bit 1 toggles if bit 0 is high before toggle (q[0] == 1)
            // Bit 2 toggles if bits 0 and 1 are high before toggle
            // Bit 3 toggles if bits 0, 1, and 2 are high before toggle
            
            // Compute enables based on current q (before toggle)
            wire enable_bit1 = q[0];
            wire enable_bit2 = q[0] & q[1];
            wire enable_bit3 = q[0] & q[1] & q[2];

            // Toggle bit 0 every cycle
            q[0] <= ~q[0];

            // Toggle higher bits only if enabled to reduce toggling power
            q[1] <= enable_bit1 ? ~q[1] : q[1];
            q[2] <= enable_bit2 ? ~q[2] : q[2];
            q[3] <= enable_bit3 ? ~q[3] : q[3];
        end
    end

endmodule