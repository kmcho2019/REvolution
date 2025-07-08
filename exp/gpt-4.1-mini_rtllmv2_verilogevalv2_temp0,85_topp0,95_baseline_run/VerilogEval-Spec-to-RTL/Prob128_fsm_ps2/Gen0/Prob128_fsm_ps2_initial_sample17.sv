module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        BYTE1 = 2'b01,
        BYTE2 = 2'b10,
        BYTE3 = 2'b11
    } state_t;

    state_t state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            state <= next_state;
            // done is asserted only when moving out of BYTE3 (i.e. after third byte received)
            done <= (state == BYTE3);
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                // Wait for a byte with in[3]=1
                if (in[3]) begin
                    next_state = BYTE1;
                end else begin
                    next_state = IDLE;
                end
            end
            BYTE1: begin
                // Received first byte, next byte is second byte
                next_state = BYTE2;
            end
            BYTE2: begin
                // Received second byte, next is third byte
                next_state = BYTE3;
            end
            BYTE3: begin
                // After third byte, go back to IDLE to search for next message
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule