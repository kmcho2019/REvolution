module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    typedef enum reg [1:0] {
        IDLE  = 2'd0,
        BYTE1 = 2'd1,
        BYTE2 = 2'd2,
        BYTE3 = 2'd3
    } state_t;

    reg [7:0] byte1, byte2, byte3;
    reg [1:0] state, next_state;

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic and data capture
    always @(*) begin
        // Defaults
        next_state = state;
    end

    always @(posedge clk) begin
        done <= 1'b0;  // Default done low each cycle

        if (reset) begin
            byte1 <= 8'd0;
            byte2 <= 8'd0;
            byte3 <= 8'd0;
            out_bytes <= 24'd0;
        end else begin
            case(state)
                IDLE: begin
                    if (in[3]) begin
                        byte1 <= in;
                        next_state <= BYTE1;
                    end else begin
                        next_state <= IDLE;
                    end
                end
                BYTE1: begin
                    byte2 <= in;
                    next_state <= BYTE2;
                end
                BYTE2: begin
                    byte3 <= in;
                    out_bytes <= {byte1, byte2, in};
                    done <= 1'b1;
                    next_state <= IDLE;
                end
                default: begin
                    next_state <= IDLE;
                end
            endcase
        end
    end

endmodule