module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    typedef enum reg [1:0] {
        IDLE = 2'b00,
        BYTE2 = 2'b01,
        BYTE3 = 2'b10
    } state_t;

    state_t state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default no done
            if (state == BYTE3) begin
                done <= 1'b1; // done at cycle after 3rd byte received
            end
        end
    end

    always @(*) begin
        case(state)
            IDLE: begin
                if (in[3] == 1'b1)
                    next_state = BYTE2;
                else
                    next_state = IDLE;
            end
            BYTE2: begin
                if (in[3] == 1'b1)
                    next_state = BYTE2; // treat as new message start
                else
                    next_state = BYTE3;
            end
            BYTE3: begin
                if (in[3] == 1'b1)
                    next_state = BYTE2; // new message start after done
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule