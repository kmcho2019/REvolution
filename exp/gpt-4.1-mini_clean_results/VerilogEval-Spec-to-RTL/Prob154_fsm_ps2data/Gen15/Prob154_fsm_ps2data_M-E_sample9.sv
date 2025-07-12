module TopModule (
    input          clk,
    input          reset,
    input  [7:0]   in,
    output reg [23:0] out_bytes,
    output reg     done
);

    typedef enum reg [1:0] {
        IDLE  = 2'b00,
        BYTE2 = 2'b01,
        BYTE3 = 2'b10
    } state_t;

    reg [1:0] state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            out_bytes <= 24'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0;

            case (state)
                IDLE: begin
                    // Look for byte with in[3]==1 to start message
                    if (in[3]) begin
                        out_bytes <= {in, 16'd0};  // Place first byte at MSB
                    end
                end
                BYTE2: begin
                    // Shift previous bytes left 8 bits, insert new byte LSB
                    out_bytes <= {out_bytes[15:0], in};
                end
                BYTE3: begin
                    // Shift again, insert third byte, and assert done
                    out_bytes <= {out_bytes[15:0], in};
                    done <= 1'b1;
                end
                default: begin
                    out_bytes <= 24'd0;
                    done <= 1'b0;
                end
            endcase
        end
    end

    always @(*) begin
        case (state)
            IDLE:  next_state = in[3] ? BYTE2 : IDLE;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule