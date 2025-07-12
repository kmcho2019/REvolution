module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output        done
);

    // FSM states
    localparam WAIT_SYNC = 2'd0;
    localparam BYTE2     = 2'd1;
    localparam BYTE3     = 2'd2;

    reg [1:0] state, next_state;

    // Byte load enable signals
    wire load_byte1 = (state == WAIT_SYNC) && in[3];
    wire load_byte2 = (state == BYTE2);
    wire load_byte3 = (state == BYTE3);

    // done is combinational: asserted immediately after the third byte is latched,
    // i.e. when state is BYTE3 (third byte being latched this cycle),
    // done asserted next cycle after BYTE3 means done = (state == BYTE3)
    // But since done must be asserted in cycle immediately after receiving the third byte,
    // and out_bytes updated on BYTE3 cycle, done is asserted when state == BYTE3.
    assign done = (state == BYTE3);

    // Sequential logic for state and out_bytes
    always @(posedge clk) begin
        if (reset) begin
            state     <= WAIT_SYNC;
            out_bytes <= 24'd0;
        end else begin
            state <= next_state;

            // Partial byte updates based on enables
            if (load_byte1)
                out_bytes[23:16] <= in;
            if (load_byte2)
                out_bytes[15:8] <= in;
            if (load_byte3)
                out_bytes[7:0] <= in;
        end
    end

    // Next state logic: purely combinational
    always @(*) begin
        case (state)
            WAIT_SYNC: next_state = in[3] ? BYTE2 : WAIT_SYNC;
            BYTE2:     next_state = BYTE3;
            BYTE3:     next_state = WAIT_SYNC;
            default:   next_state = WAIT_SYNC;
        endcase
    end

endmodule