module TopModule (
    input  wire clk,
    input  wire reset,    // synchronous active high reset
    output reg  shift_ena
);

    // FSM states
    typedef enum reg [0:0] {IDLE = 1'b0, ENABLE = 1'b1} state_t;
    reg state_t state, next_state;

    reg [1:0] count;  // 2 bits to count from 4 down to 0

    // State register and counter update
    always @(posedge clk) begin
        if (reset) begin
            state <= ENABLE;
            count <= 2'd3;  // 3 counts remaining after this cycle for 4 cycles total
        end else begin
            state <= next_state;

            if (state == ENABLE) begin
                if (count != 0)
                    count <= count - 1;
            end else begin
                count <= 2'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:    next_state = IDLE;
            ENABLE:  next_state = (count == 0) ? IDLE : ENABLE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        shift_ena <= (state == ENABLE);
    end

endmodule