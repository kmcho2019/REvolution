module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output       done
);

    // State encoding
    // 2-bit state: 0 = idle/no message, 1 = byte 1 received, 2 = byte 2 received
    reg [1:0] state, next_state;

    // Next state logic combinational
    always @(*) begin
        case (state)
            2'd0: begin
                // Wait for start byte with in[3] == 1
                if (in[3])
                    next_state = 2'd1; // first byte detected
                else
                    next_state = 2'd0; // stay idle
            end
            2'd1: next_state = 2'd2;  // received second byte
            2'd2: next_state = 2'd0;  // after third byte, return to idle
            default: next_state = 2'd0;
        endcase
    end

    // State register, synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 2'd0;
        else
            state <= next_state;
    end

    // done is asserted for one cycle immediately after third byte received,
    // which is on the clock cycle state == 2 (byte 2 received) and next_state == 0 (idle)
    assign done = (state == 2'd2);

endmodule