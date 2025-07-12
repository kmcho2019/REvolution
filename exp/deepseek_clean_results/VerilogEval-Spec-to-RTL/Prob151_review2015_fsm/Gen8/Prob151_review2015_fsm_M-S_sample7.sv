module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

    // States
    typedef enum logic [1:0] {
        IDLE,
        SHIFT,
        COUNT,
        DONE
    } state_t;

    reg [1:0] state;
    reg [3:0] pattern;

    // Continuous pattern detection
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern <= 4'b0;
        end else begin
            pattern <= {pattern[2:0], data};

            case (state)
                IDLE: 
                    if (pattern == 4'b1101) 
                        state <= SHIFT;
                SHIFT: 
                    if (&pattern[1:0]) // After 2 more shifts (total 4)
                        state <= COUNT;
                COUNT: 
                    if (done_counting) 
                        state <= DONE;
                DONE: 
                    if (ack) 
                        state <= IDLE;
            endcase
        end
    end

    // Direct output assignments
    assign shift_ena = (state == SHIFT);
    assign counting = (state == COUNT);
    assign done = (state == DONE);

endmodule