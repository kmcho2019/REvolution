module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        BYTE1 = 2'b01,
        BYTE2 = 2'b10
    } state_t;

    state_t state, next_state;
    wire start_byte = in[3];

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (start_byte)
                    next_state = BYTE1;
                else
                    next_state = IDLE;
            end
            BYTE1: next_state = BYTE2;
            BYTE2: begin
                if (start_byte)
                    next_state = BYTE1; // Start of next message detected immediately
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // State register and done signal generation
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            done <= 1'b0;
            state <= next_state;
            // done asserted when third byte of message (BYTE2) received
            if (state == BYTE2) done <= 1'b1;
        end
    end

endmodule