module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        BYTE1 = 2'b01,
        BYTE2 = 2'b10,
        DONE  = 2'b11
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE:  next_state = in[3] ? BYTE1 : IDLE;
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = DONE;
            DONE:  next_state = in[3] ? BYTE1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    assign done = (current_state == DONE);

endmodule