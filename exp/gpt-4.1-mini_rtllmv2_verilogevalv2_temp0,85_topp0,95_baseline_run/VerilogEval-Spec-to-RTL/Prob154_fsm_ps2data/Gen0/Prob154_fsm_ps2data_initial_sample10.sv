module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);
    typedef enum logic [1:0] {IDLE=2'b00, BYTE1=2'b01, BYTE2=2'b10} state_t;
    state_t state, next_state;

    reg [7:0] byte1, byte2, byte3;

    // Next state logic and outputs combinational
    always @(*) begin
        done = 1'b0;
        next_state = state;
        case(state)
            IDLE: begin
                if (in[3]) // start byte found
                    next_state = BYTE1;
            end
            BYTE1: begin
                next_state = BYTE2;
            end
            BYTE2: begin
                next_state = IDLE;
                done = 1'b1;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte1 <= 8'b0;
            byte2 <= 8'b0;
            byte3 <= 8'b0;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            case(next_state)
                IDLE: begin
                    done <= 1'b0;
                    // if we are just entering BYTE1 state next cycle, bytes updated below
                    // otherwise no change
                end
                BYTE1: begin
                    byte1 <= in;
                    done <= 1'b0;
                end
                BYTE2: begin
                    byte2 <= in;
                    done <= 1'b0;
                end
                default: ;
            endcase
            if (state == BYTE2) begin
                byte3 <= in;
                out_bytes <= {byte1, byte2, in};
                done <= 1'b1;
            end
        end
    end

endmodule