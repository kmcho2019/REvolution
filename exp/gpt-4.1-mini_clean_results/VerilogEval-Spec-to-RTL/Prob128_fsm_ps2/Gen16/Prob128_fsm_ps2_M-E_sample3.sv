module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    typedef enum reg [1:0] {IDLE=2'd0, BYTE2=2'd1, BYTE3=2'd2} state_t;
    state_t state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0;  // Default no done
            if (state == BYTE3) begin
                done <= 1'b1;
            end
        end
    end

    always @* begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in[3]) next_state = BYTE2;
            end
            BYTE2: begin
                if (in[3])
                    next_state = BYTE2; // Restart message on new start byte
                else
                    next_state = BYTE3;
            end
            BYTE3: begin
                if (in[3])
                    next_state = BYTE2; // New message start immediately after done
                else
                    next_state = IDLE;
            end
        endcase
    end

endmodule