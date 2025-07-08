module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);
    // FSM States
    typedef enum reg [1:0] {
        WAIT_FOR_START = 2'b00,
        BYTE_2         = 2'b01,
        BYTE_3         = 2'b10
    } state_t;

    reg [1:0] state, next_state;
    reg [23:0] message_reg;

    // Sequential logic: state and registers update
    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_FOR_START;
            message_reg <= 24'b0;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default no done, will be set below if needed

            case(state)
                WAIT_FOR_START: begin
                    if (in[3]) begin
                        message_reg[23:16] <= in;
                        // next_state set in combinational below
                    end
                end
                BYTE_2: begin
                    message_reg[15:8] <= in;
                end
                BYTE_3: begin
                    message_reg[7:0] <= in;
                    // done asserted next_state update below
                end
            endcase

            // When done, update output
            if (state == BYTE_3) begin
                done <= 1'b1;
                out_bytes <= message_reg;
            end
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state;
        case(state)
            WAIT_FOR_START: begin
                if (in[3]) next_state = BYTE_2;
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