module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // FSM states encoding
    typedef enum reg [1:0] {
        IDLE = 2'b00,
        BYTE2 = 2'b01,
        BYTE3 = 2'b10,
        DONE = 2'b11
    } state_t;

    state_t state, next_state;

    reg [7:0] byte1, byte2, byte3;

    // FSM next-state logic and output combinational logic
    always @(*) begin
        next_state = state;
        done = 1'b0;
        case(state)
            IDLE: begin
                if(in[3]) next_state = BYTE2;
                else next_state = IDLE;
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                next_state = DONE;
            end
            DONE: begin
                done = 1'b1;
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: FSM state update and data registers
    always @(posedge clk) begin
        if(reset) begin
            state <= IDLE;
            byte1 <= 8'b0;
            byte2 <= 8'b0;
            byte3 <= 8'b0;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    done <= 1'b0;
                    out_bytes <= 24'bx;
                    if(in[3]) begin
                        byte1 <= in;
                    end
                end
                BYTE2: begin
                    byte2 <= in;
                    done <= 1'b0;
                end
                BYTE3: begin
                    byte3 <= in;
                    done <= 1'b0;
                end
                DONE: begin
                    // Output the message and assert done
                    out_bytes <= {byte1, byte2, byte3};
                    done <= 1'b1;
                end
                default: ;
            endcase
        end
    end

endmodule