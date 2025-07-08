module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // FSM state encoding
    typedef enum reg [1:0] {
        IDLE  = 2'b00,
        BYTE2 = 2'b01,
        BYTE3 = 2'b10
    } state_t;

    state_t state, next_state;

    reg [7:0] byte1, byte2, byte3;

    // Sequential logic for state and data registers with synchronous reset
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

            done <= 1'b0; // default done to 0, asserted only after third byte

            case(state)
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
                    // Prepare output and done signal in next cycle
                end
            endcase

            // Output and done assignment when in BYTE3 state, and moving to IDLE next
            if (state == BYTE3 && next_state == IDLE) begin
                out_bytes <= {byte1, byte2, in};
                done <= 1'b1;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (in[3]) next_state = BYTE2;
                else next_state = IDLE;
            end
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule