module TopModule (
    input  wire clk,
    input  wire reset,             // synchronous active high
    input  wire pattern_detected, // input signal indicating pattern detection
    output wire shift_ena
);

    typedef enum logic [0:0] {
        IDLE  = 1'b0,
        COUNT = 1'b1
    } state_t;

    state_t state, next_state;
    reg [2:0] counter, next_counter;

    // Next state and counter logic combinational block
    always @(*) begin
        next_state = state;
        next_counter = counter;

        case (state)
            IDLE: begin
                // On reset or pattern detection, start counting
                if (reset || pattern_detected) begin
                    next_state = COUNT;
                    next_counter = 3'd4; // enable shift_ena for 4 cycles
                end
            end

            COUNT: begin
                if (counter != 0) begin
                    next_counter = counter - 1;
                end else begin
                    next_state = IDLE;
                end
            end
        endcase
    end

    // Sequential block: update state and counter on positive clock edge
    always @(posedge clk) begin
        if (reset) begin
            state <= COUNT;
            counter <= 3'd4;
        end else begin
            state <= next_state;
            counter <= next_counter;
        end
    end

    assign shift_ena = (state == COUNT) && (counter != 0);

endmodule