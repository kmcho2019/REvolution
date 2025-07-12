module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    typedef enum logic [2:0] {
        IDLE  = 3'd0,
        BYTE1 = 3'd1,
        BYTE2 = 3'd2,
        BYTE3 = 3'd3,
        DONE  = 3'd4
    } state_t;

    state_t state, next_state;

    reg [7:0] byte1, byte2, byte3;

    // State register and output update
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            byte1     <= 8'd0;
            byte2     <= 8'd0;
            byte3     <= 8'd0;
            out_bytes <= 24'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (in[3]) begin
                        byte1 <= in;
                    end
                end

                BYTE1: begin
                    done <= 1'b0;
                    byte2 <= in;
                end

                BYTE2: begin
                    done <= 1'b0;
                    byte3 <= in;
                end

                BYTE3: begin
                    done <= 1'b0;
                    // No new byte captured here; wait for DONE state to output
                end

                DONE: begin
                    done <= 1'b1;
                    out_bytes <= {byte1, byte2, byte3};
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
            IDLE:  next_state = in[3] ? BYTE1 : IDLE;
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = DONE;
            DONE:  next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule