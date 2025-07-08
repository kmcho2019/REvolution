module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // States
    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        BYTE2 = 2'b01,
        BYTE3 = 2'b10
    } state_t;

    state_t state, next_state;

    reg [23:0] msg_reg;
    reg done_next;

    // State transition and output logic
    always @(*) begin
        done_next = 0;
        next_state = state;

        case (state)
            IDLE: begin
                // Wait for a byte with in[3] == 1
                if (in[3]) begin
                    next_state = BYTE2;
                end
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                done_next = 1;
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state update and data capture
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            msg_reg <= 24'b0;
            done <= 0;
            out_bytes <= 24'b0;
        end else begin
            state <= next_state;
            done <= done_next;

            case (state)
                IDLE: begin
                    if (in[3]) begin
                        // Capture first byte at bits [23:16]
                        msg_reg[23:16] <= in;
                    end
                end
                BYTE2: begin
                    // Capture second byte at bits [15:8]
                    msg_reg[15:8] <= in;
                end
                BYTE3: begin
                    // Capture third byte at bits [7:0]
                    msg_reg[7:0] <= in;
                    if (done_next) begin
                        // Output message on done cycle
                        out_bytes <= {msg_reg[23:16], msg_reg[15:8], in};
                    end
                end
            endcase
        end
    end

endmodule