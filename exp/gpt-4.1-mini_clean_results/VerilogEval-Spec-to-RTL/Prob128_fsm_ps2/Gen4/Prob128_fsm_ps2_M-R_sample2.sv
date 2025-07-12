module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output       done
);

    // One-hot state encoding
    reg idle, byte2, byte3;
    reg idle_next, byte2_next, byte3_next;

    // Output is combinational: done is high only when in BYTE3 state (indicating third byte received)
    assign done = byte3;

    // Next state logic
    always @(*) begin
        idle_next  = 1'b0;
        byte2_next = 1'b0;
        byte3_next = 1'b0;

        if (idle) begin
            if (in[3])
                byte2_next = 1'b1;
            else
                idle_next = 1'b1;
        end else if (byte2) begin
            byte3_next = 1'b1;
        end else if (byte3) begin
            idle_next = 1'b1;
        end else begin
            // Default to idle if no state active
            idle_next = 1'b1;
        end
    end

    // State register update with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            idle  <= 1'b1;
            byte2 <= 1'b0;
            byte3 <= 1'b0;
        end else begin
            idle  <= idle_next;
            byte2 <= byte2_next;
            byte3 <= byte3_next;
        end
    end

endmodule