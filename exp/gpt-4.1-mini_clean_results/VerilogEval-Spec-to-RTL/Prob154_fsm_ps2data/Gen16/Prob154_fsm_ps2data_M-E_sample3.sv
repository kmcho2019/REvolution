module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // Define FSM states
    typedef enum reg [1:0] {
        IDLE  = 2'd0,
        BYTE1 = 2'd1,
        BYTE2 = 2'd2,
        BYTE3 = 2'd3
    } state_t;

    state_t state;

    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            out_bytes <= 24'd0;
            done      <= 1'b0;
        end else begin
            done <= 1'b0;  // Default done low each cycle

            case(state)
                IDLE: begin
                    // Look for start byte: in[3] == 1
                    if (in[3]) begin
                        out_bytes[23:16] <= in;  // Capture first byte (MSB)
                        state <= BYTE1;
                    end
                end

                BYTE1: begin
                    out_bytes[15:8] <= in;  // Capture second byte (middle)
                    state <= BYTE2;
                end

                BYTE2: begin
                    out_bytes[7:0] <= in;   // Capture third byte (LSB)
                    done <= 1'b1;           // Signal message done
                    state <= IDLE;
                end

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule