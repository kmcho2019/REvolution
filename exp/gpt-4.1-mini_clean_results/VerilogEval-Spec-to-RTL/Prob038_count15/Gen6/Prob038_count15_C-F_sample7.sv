module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    // Generate enable signals for toggling each bit
    wire enable_bit1 = q[0];
    wire enable_bit2 = q[0] & q[1];
    wire enable_bit3 = q[0] & q[1] & q[2];

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0000;
        end else begin
            // Toggle bit 0 every cycle
            q[0] <= ~q[0];
            // Toggle bit 1 when enable_bit1 is high
            q[1] <= q[1] ^ enable_bit1;
            // Toggle bit 2 when enable_bit2 is high
            q[2] <= q[2] ^ enable_bit2;
            // Toggle bit 3 when enable_bit3 is high
            q[3] <= q[3] ^ enable_bit3;
        end
    end

endmodule