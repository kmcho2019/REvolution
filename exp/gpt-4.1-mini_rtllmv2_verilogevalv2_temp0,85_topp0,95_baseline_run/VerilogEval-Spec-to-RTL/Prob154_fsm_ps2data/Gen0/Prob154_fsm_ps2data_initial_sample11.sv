module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    typedef enum logic [1:0] {IDLE=2'b00, BYTE2=2'b01, BYTE3=2'b10} state_t;
    state_t state, next_state;

    reg [7:0] byte1, byte2, byte3;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            out_bytes <= 24'b0;
            done <= 1'b0;
            byte1 <= 8'b0;
            byte2 <= 8'b0;
            byte3 <= 8'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // done is one cycle pulse only

            case (state)
                IDLE: begin
                    if (in[3]) begin
                        byte1 <= in;
                    end
                end
                BYTE2: begin
                    byte2 <= in;
                end
                BYTE3: begin
                    byte3 <= in;
                    // when third byte received, update out_bytes and assert done
                    out_bytes <= {byte1, byte2, in};
                    done <= 1'b1;
                end
                default: ;
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state;
        case (state)
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