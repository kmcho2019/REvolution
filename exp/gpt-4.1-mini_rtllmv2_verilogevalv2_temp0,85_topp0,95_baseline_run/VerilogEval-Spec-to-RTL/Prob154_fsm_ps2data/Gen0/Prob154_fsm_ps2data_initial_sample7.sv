module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);
    typedef enum reg [1:0] {IDLE=2'd0, BYTE1=2'd1, BYTE2=2'd2, BYTE3=2'd3} state_t;
    reg [7:0] byte1, byte2, byte3;
    state_t state, next_state;

    // State register and synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte1 <= 8'd0;
            byte2 <= 8'd0;
            byte3 <= 8'd0;
            out_bytes <= 24'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // done only asserted one cycle after third byte received
            case(state)
                IDLE: begin
                    if (in[3] == 1'b1) begin
                        byte1 <= in;
                    end
                end
                BYTE1: begin
                    byte2 <= in;
                end
                BYTE2: begin
                    byte3 <= in;
                end
                BYTE3: begin
                    // Output message and assert done in next cycle (state transition)
                    out_bytes <= {byte1, byte2, byte3};
                    done <= 1'b1;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (in[3] == 1'b1)
                    next_state = BYTE1;
            end
            BYTE1: begin
                next_state = BYTE2;
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule