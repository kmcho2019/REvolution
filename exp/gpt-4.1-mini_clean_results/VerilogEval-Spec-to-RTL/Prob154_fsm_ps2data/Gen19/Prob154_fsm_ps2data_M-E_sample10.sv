module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        BYTE2 = 2'b01,
        BYTE3 = 2'b10
    } state_t;

    state_t state, next_state;

    reg [7:0] byte1, byte2, byte3;

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state    <= IDLE;
            byte1    <= 8'b0;
            byte2    <= 8'b0;
            byte3    <= 8'b0;
            out_bytes<= 24'b0;
            done     <= 1'b0;
        end else begin
            state <= next_state;

            // Default done low, will be asserted only for one cycle in BYTE3
            done <= 1'b0;

            case(state)
                IDLE: begin
                    // Wait for in[3] == 1 to start
                    if (in[3]) begin
                        byte1 <= in;
                    end
                end
                BYTE2: begin
                    byte2 <= in;
                end
                BYTE3: begin
                    byte3 <= in;
                    done <= 1'b1;
                    // Update out_bytes with complete message
                    out_bytes <= {byte1, byte2, in};
                end
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        case(state)
            IDLE:  next_state = in[3] ? BYTE2 : IDLE;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule