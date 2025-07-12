module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output [23:0] out_bytes,
    output        done
);

    // State encoding
    typedef enum logic [1:0] {
        WAIT_SYNC = 2'd0,
        BYTE2     = 2'd1,
        BYTE3     = 2'd2
    } state_t;

    state_t state, next_state;

    // Registers for storing bytes explicitly
    reg [7:0] byte1, byte2, byte3;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_SYNC;
            byte1 <= 8'd0;
            byte2 <= 8'd0;
            byte3 <= 8'd0;
        end else begin
            state <= next_state;
            case (state)
                WAIT_SYNC: if (in[3]) byte1 <= in;
                BYTE2:      byte2 <= in;
                BYTE3:      byte3 <= in;
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        case(state)
            WAIT_SYNC: next_state = in[3] ? BYTE2 : WAIT_SYNC;
            BYTE2:     next_state = BYTE3;
            BYTE3:     next_state = WAIT_SYNC;
            default:   next_state = WAIT_SYNC;
        endcase
    end

    // Done signal combinational: one cycle after third byte stored
    assign done = (state == BYTE3);

    // Combine bytes into output
    assign out_bytes = {byte1, byte2, byte3};

endmodule