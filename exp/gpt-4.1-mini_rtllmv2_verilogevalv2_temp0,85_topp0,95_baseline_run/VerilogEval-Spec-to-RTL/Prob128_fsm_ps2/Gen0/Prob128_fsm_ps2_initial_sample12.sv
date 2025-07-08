module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    typedef enum reg [1:0] {
        IDLE = 2'd0,
        BYTE2 = 2'd1,
        BYTE3 = 2'd2
    } state_t;

    reg [1:0] state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            state <= next_state;
            // done is only asserted for one cycle immediately after third byte received
            if (state == BYTE3)
                done <= 1'b1;
            else
                done <= 1'b0;
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (in[3] == 1'b1)
                    next_state = BYTE2;
                else
                    next_state = IDLE;
            end
            BYTE2: begin
                // byte 2 received, move to byte 3 regardless of in[3]
                next_state = BYTE3;
            end
            BYTE3: begin
                // after third byte, go back to IDLE to search for next message
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule