module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // FSM states
    typedef enum reg [1:0] {
        IDLE  = 2'b00,
        BYTE1 = 2'b01,
        BYTE2 = 2'b10,
        BYTE3 = 2'b11
    } state_t;

    reg [1:0] state, next_state;

    // FSM sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            out_bytes <= 24'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            done <= 1'b0; // default done low

            case(state)
                IDLE: begin
                    if (in[3]) begin
                        // Start message: load first byte
                        out_bytes <= {in, 16'd0};
                        next_state <= BYTE1;
                    end else begin
                        // Stay idle if start byte not detected
                        next_state <= IDLE;
                    end
                end
                BYTE1: begin
                    // Shift in second byte at right
                    out_bytes <= {out_bytes[15:0], in};
                    next_state <= BYTE2;
                end
                BYTE2: begin
                    // Shift in third byte at right, assert done next cycle
                    out_bytes <= {out_bytes[15:0], in};
                    done <= 1'b1;
                    next_state <= IDLE;
                end
                default: begin
                    next_state <= IDLE; // Safe fallback
                end
            endcase
        end
    end

endmodule