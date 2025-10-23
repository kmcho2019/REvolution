module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // FSM states
    typedef enum reg [1:0] {IDLE=2'b00, BYTE2=2'b01, BYTE3=2'b10} state_t;
    state_t state, next_state;

    reg [7:0] b1, b2;

    // State and data registers update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            b1 <= 8'd0;
            b2 <= 8'd0;
            out_bytes <= 24'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0;

            case (state)
                IDLE: if (in[3]) b1 <= in;
                BYTE2: b2 <= in;
                BYTE3: begin
                    out_bytes <= {b1, b2, in};
                    done <= 1'b1;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = in[3] ? BYTE2 : IDLE;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule