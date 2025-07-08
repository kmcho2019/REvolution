module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // FSM states encoding
    typedef enum reg [1:0] {
        WAIT_FOR_START = 2'b00,
        BYTE_2         = 2'b01,
        BYTE_3         = 2'b10
    } state_t;

    state_t state, next_state;

    reg [7:0] byte1, byte2, byte3;

    // State transition logic (combinational)
    always @(*) begin
        next_state = state;
        case(state)
            WAIT_FOR_START: begin
                if (in[3] == 1'b1)
                    next_state = BYTE_2;
                else
                    next_state = WAIT_FOR_START;
            end
            BYTE_2: next_state = BYTE_3;
            BYTE_3: next_state = WAIT_FOR_START;
            default: next_state = WAIT_FOR_START;
        endcase
    end

    // Sequential logic for state, outputs and registers
    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_FOR_START;
            byte1 <= 8'b0;
            byte2 <= 8'b0;
            byte3 <= 8'b0;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                WAIT_FOR_START: begin
                    done <= 1'b0;
                    if (in[3] == 1'b1) begin
                        byte1 <= in;
                    end
                end
                BYTE_2: begin
                    byte2 <= in;
                    done <= 1'b0;
                end
                BYTE_3: begin
                    byte3 <= in;
                    out_bytes <= {byte1, byte2, in};
                    done <= 1'b1;
                end
                default: begin
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule