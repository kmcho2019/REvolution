module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    typedef enum reg [1:0] {
        IDLE  = 2'd0,
        BYTE2 = 2'd1,
        BYTE3 = 2'd2
    } state_t;

    state_t state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            state <= next_state;
            // done is asserted only one cycle after third byte received
            if (state == BYTE3)
                done <= 1'b1;
            else
                done <= 1'b0;
        end
    end

    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (in[3]) 
                    next_state = BYTE2;
            end
            BYTE2: begin
                // second byte received, go to BYTE3
                next_state = BYTE3;
            end
            BYTE3: begin
                // third byte received, after done signal return to IDLE to look for next message
                next_state = IDLE;
            end
        endcase
    end

endmodule