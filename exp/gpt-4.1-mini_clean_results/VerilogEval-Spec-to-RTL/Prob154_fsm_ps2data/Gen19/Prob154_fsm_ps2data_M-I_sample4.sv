module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // FSM states
    localparam WAIT_SYNC = 2'd0;
    localparam BYTE2     = 2'd1;
    localparam BYTE3     = 2'd2;

    reg [1:0] state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state     <= WAIT_SYNC;
            out_bytes <= 24'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default done low

            case (state)
                WAIT_SYNC: begin
                    if (in[3]) begin
                        // Start of message, load first byte to bits [23:16]
                        out_bytes <= {in, 16'd0};
                    end
                end

                BYTE2: begin
                    // Shift out_bytes left 8 bits and load new byte at LSB
                    out_bytes <= {out_bytes[15:0], in};
                end

                BYTE3: begin
                    // Shift out_bytes left 8 bits and load new byte at LSB
                    // Message complete; assert done
                    out_bytes <= {out_bytes[15:0], in};
                    done <= 1'b1;
                end

                default: begin
                    out_bytes <= 24'd0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            WAIT_SYNC: next_state = in[3] ? BYTE2 : WAIT_SYNC;
            BYTE2:     next_state = BYTE3;
            BYTE3:     next_state = WAIT_SYNC;
            default:   next_state = WAIT_SYNC;
        endcase
    end

endmodule