module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output       done
);

    reg waiting, byte2, byte3;
    reg waiting_d, byte2_d, byte3_d;

    // State update with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            waiting <= 1'b1;
            byte2   <= 1'b0;
            byte3   <= 1'b0;
        end else begin
            waiting <= waiting_d;
            byte2   <= byte2_d;
            byte3   <= byte3_d;
        end
    end

    // Next state logic
    always @(*) begin
        // Default next states to current
        waiting_d = waiting;
        byte2_d   = byte2;
        byte3_d   = byte3;

        if (waiting) begin
            if (in[3])
                begin waiting_d = 1'b0; byte2_d = 1'b1; byte3_d = 1'b0; end
            else
                begin waiting_d = 1'b1; byte2_d = 1'b0; byte3_d = 1'b0; end
        end else if (byte2) begin
            waiting_d = 1'b0;
            byte2_d   = 1'b0;
            byte3_d   = 1'b1;
        end else if (byte3) begin
            waiting_d = 1'b1;
            byte2_d   = 1'b0;
            byte3_d   = 1'b0;
        end
    end

    // done is high one cycle immediately after the third byte is received
    assign done = byte3;

endmodule