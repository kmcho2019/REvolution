module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output done
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'd0,
        BYTE1 = 2'd1,
        BYTE2 = 2'd2
    } state_t;

    state_t state, next_state;

    // Registers to store the 3 bytes
    reg [7:0] msg_bytes [2:0];

    // Combinational next state logic
    always @(*) begin
        case(state)
            IDLE: next_state = (in[3]) ? BYTE1 : IDLE;
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // done signal asserted combinationally when in BYTE2 state (ready to output)
    assign done = (state == BYTE2);

    // Sequential logic: state and message byte registers updated synchronously
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            msg_bytes[0] <= 8'd0;
            msg_bytes[1] <= 8'd0;
            msg_bytes[2] <= 8'd0;
            out_bytes <= 24'd0;
        end else begin
            state <= next_state;

            case(next_state)
                BYTE1: msg_bytes[0] <= in;        // Capture first byte when entering BYTE1
                BYTE2: msg_bytes[1] <= in;        // Capture second byte when entering BYTE2
                IDLE: begin
                    if (state == BYTE2) begin
                        msg_bytes[2] <= in;       // Capture third byte just before returning IDLE
                        // Concatenate 3 bytes in order on done cycle (which is state BYTE2)
                        out_bytes <= {msg_bytes[0], msg_bytes[1], in};
                    end
                end
            endcase
        end
    end

endmodule