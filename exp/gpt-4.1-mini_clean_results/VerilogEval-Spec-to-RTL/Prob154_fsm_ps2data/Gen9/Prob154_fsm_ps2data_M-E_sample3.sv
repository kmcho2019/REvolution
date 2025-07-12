module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // State encoding
    typedef enum reg [1:0] {
        IDLE  = 2'b00,
        BYTE2 = 2'b01,
        BYTE3 = 2'b10
    } state_t;

    reg [1:0] state, next_state;

    // 3-byte buffer to hold the message
    reg [7:0] buf0, buf1, buf2;

    // State transition logic (next state combinational)
    always @(*) begin
        case(state)
            IDLE:   next_state = (in[3]) ? BYTE2 : IDLE;
            BYTE2:  next_state = BYTE3;
            BYTE3:  next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state, buffer, output, done update
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            buf0      <= 8'b0;
            buf1      <= 8'b0;
            buf2      <= 8'b0;
            out_bytes <= 24'b0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done  <= 1'b0;

            case (state)
                IDLE: begin
                    if (in[3]) begin
                        buf0 <= in;
                    end
                end
                BYTE2: begin
                    buf1 <= in;
                end
                BYTE3: begin
                    buf2      <= in;
                    out_bytes <= {buf0, buf1, in};
                    done      <= 1'b1;
                end
            endcase
        end
    end

endmodule