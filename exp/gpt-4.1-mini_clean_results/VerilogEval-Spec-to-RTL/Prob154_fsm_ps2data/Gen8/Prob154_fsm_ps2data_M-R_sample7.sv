module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output       done
);

    // FSM states
    typedef enum logic [1:0] {
        WAIT_SYNC = 2'b00,
        BYTE2     = 2'b01,
        BYTE3     = 2'b10,
        DONE      = 2'b11
    } state_t;

    state_t state, next_state;

    // Byte registers
    reg [7:0] byte1, byte2;

    // State transition
    always @(posedge clk) begin
        if (reset)
            state <= WAIT_SYNC;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case(state)
            WAIT_SYNC: next_state = in[3] ? BYTE2 : WAIT_SYNC;
            BYTE2:     next_state = BYTE3;
            BYTE3:     next_state = DONE;
            DONE:      next_state = WAIT_SYNC;
            default:   next_state = WAIT_SYNC;
        endcase
    end

    // Data path: bytes loading synchronous to clk
    always @(posedge clk) begin
        if (reset) begin
            byte1 <= 8'd0;
            byte2 <= 8'd0;
            out_bytes <= 24'd0;
        end else begin
            case(state)
                WAIT_SYNC: if (in[3]) byte1 <= in;
                BYTE2:     byte2 <= in;
                DONE:      out_bytes <= {byte1, byte2, in};
                default:   ; // no change
            endcase
        end
    end

    // Done signal is high only in DONE state, combinational output
    assign done = (state == DONE);

endmodule