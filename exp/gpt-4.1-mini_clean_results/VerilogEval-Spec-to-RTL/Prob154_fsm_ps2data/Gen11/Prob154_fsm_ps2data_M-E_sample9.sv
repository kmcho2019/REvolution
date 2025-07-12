module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    typedef enum logic [1:0] {IDLE=2'b00, BYTE1=2'b01, BYTE2=2'b10} state_t;
    state_t state, next_state;

    reg [7:0] byte1, byte2, byte3;
    reg [23:0] message_reg;

    // Next state logic and data capture
    always @(*) begin
        done = 1'b0;
        next_state = state;
        case(state)
            IDLE: begin
                if (in[3]) begin
                    next_state = BYTE1;
                end
            end
            BYTE1: begin
                next_state = BYTE2;
            end
            BYTE2: begin
                next_state = IDLE;
                done = 1'b1;
            end
        endcase
    end

    // Sequential logic: state update and data registers
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte1 <= 8'd0;
            byte2 <= 8'd0;
            byte3 <= 8'd0;
            message_reg <= 24'd0;
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
                BYTE1: begin
                    done <= 1'b0;
                    byte2 <= in;
                end
                BYTE2: begin
                    byte3 <= in;
                    // Assemble message and output with done asserted
                    message_reg <= {byte1, byte2, in};
                    out_bytes <= {byte1, byte2, in};
                    done <= 1'b1;
                end
            endcase
        end
    end

endmodule