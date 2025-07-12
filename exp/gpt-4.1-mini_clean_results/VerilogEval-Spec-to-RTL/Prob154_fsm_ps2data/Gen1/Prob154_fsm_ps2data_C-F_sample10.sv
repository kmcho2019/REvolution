module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // State encoding
    localparam WAIT_SYNC = 2'd0;
    localparam BYTE2     = 2'd1;
    localparam BYTE3     = 2'd2;

    reg [1:0] state, next_state;

    reg [7:0] byte1, byte2, byte3;

    // Sequential logic: state, bytes, outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_SYNC;
            byte1 <= 8'd0;
            byte2 <= 8'd0;
            byte3 <= 8'd0;
            out_bytes <= 24'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                WAIT_SYNC: begin
                    done <= 1'b0;
                    if (in[3]) begin
                        byte1 <= in;
                    end
                end
                BYTE2: begin
                    done <= 1'b0;
                    byte2 <= in;
                end
                BYTE3: begin
                    byte3 <= in;
                    done <= 1'b1;
                    out_bytes <= {byte1, byte2, in};
                end
                default: begin
                    done <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            WAIT_SYNC: next_state = (in[3]) ? BYTE2 : WAIT_SYNC;
            BYTE2:     next_state = BYTE3;
            BYTE3:     next_state = WAIT_SYNC;
            default:   next_state = WAIT_SYNC;
        endcase
    end

endmodule