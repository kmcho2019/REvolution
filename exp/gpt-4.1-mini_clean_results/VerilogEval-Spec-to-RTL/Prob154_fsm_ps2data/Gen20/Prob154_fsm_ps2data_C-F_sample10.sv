module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // FSM state encoding
    localparam WAIT_SYNC = 2'd0;
    localparam BYTE2     = 2'd1;
    localparam BYTE3     = 2'd2;

    reg [1:0] state, next_state;

    // Load enable: true when first byte found or in subsequent byte states
    wire load_en = (state == WAIT_SYNC && in[3]) || (state == BYTE2) || (state == BYTE3);

    always @(posedge clk) begin
        if (reset) begin
            state     <= WAIT_SYNC;
            out_bytes <= 24'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            done <= 1'b0; // default done low each cycle

            if (load_en) begin
                // Shift out_bytes left by 8 bits and insert new byte at LSB
                out_bytes <= {out_bytes[15:0], in};
            end

            // Assert done only in the cycle after receiving the third byte
            if (state == BYTE3)
                done <= 1'b1;
        end
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            WAIT_SYNC: next_state = in[3] ? BYTE2 : WAIT_SYNC;
            BYTE2:     next_state = BYTE3;
            BYTE3:     next_state = WAIT_SYNC;
            default:   next_state = WAIT_SYNC;
        endcase
    end

endmodule