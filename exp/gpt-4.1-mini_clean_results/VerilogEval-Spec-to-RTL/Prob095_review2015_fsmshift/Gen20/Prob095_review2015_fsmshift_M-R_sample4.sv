module TopModule (
    input  wire clk,
    input  wire reset,      // synchronous active-high reset
    output reg  shift_ena
);

    // FSM states
    typedef enum logic [0:0] {
        IDLE     = 1'b0,
        SHIFTING = 1'b1
    } state_t;

    state_t state, next_state;
    reg [2:0] counter, next_counter;

    // Next-state logic
    always @(*) begin
        // Default assignments
        next_state  = state;
        next_counter = counter;

        case (state)
            IDLE: begin
                // On reset, start shifting
                if (reset) begin
                    next_state   = SHIFTING;
                    next_counter = 3'd4;
                end
            end
            SHIFTING: begin
                if (counter == 3'd1) begin
                    next_state   = IDLE;
                    next_counter = 3'd0;
                end else begin
                    next_counter = counter - 3'd1;
                end
            end
        endcase
    end

    // Sequential state and counter update
    always @(posedge clk) begin
        if (reset) begin
            state   <= SHIFTING;
            counter <= 3'd4;
        end else begin
            state   <= next_state;
            counter <= next_counter;
        end
    end

    // Output logic: shift_ena asserted only in SHIFTING state
    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b1;
        end else begin
            shift_ena <= (state == SHIFTING);
        end
    end

endmodule