module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // State encoding for Mealy FSM detecting sequence "1101"
    typedef enum reg [1:0] {
        IDLE = 2'b00,     // no bits matched
        S1   = 2'b01,     // matched '1'
        S11  = 2'b10,     // matched "11"
        S110 = 2'b11      // matched "110"
    } state_t;

    state_t state, next_state;

    // Combinational next state logic and output generation (Mealy)
    // start_shifting_next is asserted immediately when sequence detected
    reg start_shifting_next;
    always @(*) begin
        start_shifting_next = start_shifting; // default hold previous output
        case (state)
            IDLE: begin
                if (data)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            S1: begin
                if (data)
                    next_state = S11;
                else
                    next_state = IDLE;
            end
            S11: begin
                if (data)
                    next_state = S11;
                else
                    next_state = S110;
            end
            S110: begin
                if (data) begin
                    next_state = S1;       // overlapping sequences allowed
                    start_shifting_next = 1'b1; // sequence 1101 detected here
                end else begin
                    next_state = IDLE;
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // Sequential logic for state and start_shifting output
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            start_shifting <= start_shifting_next;
        end
    end

endmodule