module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    typedef enum reg [1:0] {WAIT=2'd0, BYTE2=2'd1, BYTE3=2'd2} state_t;
    state_t state, next_state;

    reg [7:0] byte1, byte2;

    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT;
            byte1 <= 8'd0;
            byte2 <= 8'd0;
            out_bytes <= 24'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0;

            case(state)
                WAIT: begin
                    if (in[3]) byte1 <= in;
                end
                BYTE2: byte2 <= in;
                BYTE3: begin
                    out_bytes <= {byte1, byte2, in};
                    done <= 1'b1;
                end
            endcase
        end
    end

    always @(*) begin
        case(state)
            WAIT:  next_state = in[3] ? BYTE2 : WAIT;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = WAIT;
            default: next_state = WAIT;
        endcase
    end

endmodule