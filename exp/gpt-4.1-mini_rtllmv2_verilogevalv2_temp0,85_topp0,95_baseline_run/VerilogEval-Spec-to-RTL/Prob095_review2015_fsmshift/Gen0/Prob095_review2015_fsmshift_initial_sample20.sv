module TopModule (
    input  wire clk,
    input  wire reset,
    output reg  shift_ena
);

    // States for FSM
    typedef enum logic [0:0] {
        ACTIVE = 1'b0,
        IDLE   = 1'b1
    } state_t;

    state_t state, next_state;
    reg [2:0] cnt; // 3-bit counter to count to 4

    // Synchronous state and counter update
    always @(posedge clk) begin
        if (reset) begin
            state <= ACTIVE;
            cnt <= 3'd0;
        end else begin
            state <= next_state;
            if (state == ACTIVE)
                cnt <= cnt + 1;
            else
                cnt <= cnt;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            ACTIVE: next_state = (cnt == 3'd3) ? IDLE : ACTIVE;
            IDLE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(*) begin
        shift_ena = (state == ACTIVE);
    end

endmodule