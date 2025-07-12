module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    // One-hot style state encoding
    reg idle, byte2, byte3;
    reg idle_next, byte2_next, byte3_next;

    always @(posedge clk) begin
        if (reset) begin
            idle  <= 1'b1;
            byte2 <= 1'b0;
            byte3 <= 1'b0;
            done  <= 1'b0;
        end else begin
            idle  <= idle_next;
            byte2 <= byte2_next;
            byte3 <= byte3_next;
            // done asserted for one cycle immediately after third byte received (when leaving byte3)
            done  <= byte3;
        end
    end

    // Next state logic
    always @(*) begin
        // Default assignments
        idle_next  = idle;
        byte2_next = byte2;
        byte3_next = byte3;

        if (idle) begin
            if (in[3]) begin
                idle_next  = 1'b0;
                byte2_next = 1'b1;
                byte3_next = 1'b0;
            end
        end else if (byte2) begin
            idle_next  = 1'b0;
            byte2_next = 1'b0;
            byte3_next = 1'b1;
        end else if (byte3) begin
            // After signaling done, go back to idle
            idle_next  = 1'b1;
            byte2_next = 1'b0;
            byte3_next = 1'b0;
        end
    end

endmodule