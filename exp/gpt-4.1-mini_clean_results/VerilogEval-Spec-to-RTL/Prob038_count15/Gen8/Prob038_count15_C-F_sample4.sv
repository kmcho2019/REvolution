module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    // Enable signals for bits 1 to 3, derived from the lower bits being high, to control toggling
    wire enable1 = q[0];
    wire enable2 = q[0] & q[1];
    wire enable3 = q[0] & q[1] & q[2];

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0000;
        end else begin
            // Bit 0 toggles every clock cycle
            q[0] <= ~q[0];

            // Other bits toggle only when their enable signals are high
            if (enable1)
                q[1] <= ~q[1];
            if (enable2)
                q[2] <= ~q[2];
            if (enable3)
                q[3] <= ~q[3];
        end
    end

endmodule