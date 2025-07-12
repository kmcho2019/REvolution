module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // State encoding
    typedef enum reg [1:0] {
        IDLE = 2'b00,
        BYTE2 = 2'b01,
        BYTE3 = 2'b10
    } state_t;

    state_t state, next_state;

    reg [7:0] byte1, byte2, byte3;

    // State and data registers synchronous with clk and reset
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte1 <= 8'd0;
            byte2 <= 8'd0;
            byte3 <= 8'd0;
            out_bytes <= 24'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
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
                    done <= 1'b1;  // done asserted at cycle after receiving byte3
                    out_bytes <= {byte1, byte2, in};
                end
                default: begin
                    done <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        case(state)
            IDLE: begin
                if (in[3])
                    next_state = BYTE2;
                else
                    next_state = IDLE;
            end
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule