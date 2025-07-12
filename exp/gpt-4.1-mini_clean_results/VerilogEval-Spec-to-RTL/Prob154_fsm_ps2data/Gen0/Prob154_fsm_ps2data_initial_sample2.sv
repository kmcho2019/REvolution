module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    typedef enum reg [1:0] {
        IDLE = 2'b00,
        BYTE1 = 2'b01,
        BYTE2 = 2'b10
    } state_t;

    state_t state, next_state;

    reg [7:0] byte1, byte2, byte3;

    // Next state logic and datapath
    always @(*) begin
        done = 1'b0;
        next_state = state;
        case (state)
            IDLE: begin
                if (in[3]) begin
                    // Found first byte of message
                    next_state = BYTE1;
                end else begin
                    next_state = IDLE;
                end
            end
            BYTE1: begin
                next_state = BYTE2;
            end
            BYTE2: begin
                // After receiving third byte, signal done and go back to IDLE
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase

        // done is asserted on cycle after receiving third byte, which is when we are in BYTE2 and transition to IDLE
        if (state == BYTE2) begin
            done = 1'b1;
        end
    end

    // Sequential logic: state update and registers
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
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        byte1 <= in;
                    end
                end
                BYTE1: begin
                    byte2 <= in;
                end
                BYTE2: begin
                    byte3 <= in;
                    // Output assembled 3 bytes MSB first as required
                    out_bytes <= {byte1, byte2, in};
                end
            endcase
        end
    end

endmodule