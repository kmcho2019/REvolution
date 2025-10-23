module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // State encoding
    typedef enum reg [1:0] {
        WAIT_FOR_START = 2'b00,
        BYTE_2         = 2'b01,
        BYTE_3         = 2'b10
    } state_t;

    reg [7:0] byte1, byte2, byte3;
    reg [1:0] state, next_state;

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

            done <= 1'b0; // default done deassert

            case(state)
                WAIT_FOR_START: begin
                    if (in[3]) begin
                        byte1 <= in;
                        done <= 1'b0;
                    end
                end
                BYTE_2: begin
                    byte2 <= in;
                    done <= 1'b0;
                end
                BYTE_3: begin
                    byte3 <= in;
                    done <= 1'b1;
                    out_bytes <= {byte1, byte2, in};
                end
            endcase
        end
    end

    always @(*) begin
        case(state)
            WAIT_FOR_START: begin
                if (in[3])
                    next_state = BYTE_2;
                else
                    next_state = WAIT_FOR_START;
            end
            BYTE_2: begin
                next_state = BYTE_3;
            end
            BYTE_3: begin
                next_state = WAIT_FOR_START;
            end
            default: next_state = WAIT_FOR_START;
        endcase
    end

endmodule