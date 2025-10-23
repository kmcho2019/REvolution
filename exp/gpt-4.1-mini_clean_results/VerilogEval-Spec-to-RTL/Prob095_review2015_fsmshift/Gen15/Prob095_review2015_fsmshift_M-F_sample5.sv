module TopModule (
    input  wire clk,
    input  wire reset,      // synchronous active-high reset
    output reg  shift_ena
);

    // States for FSM
    typedef enum logic [0:0] {
        IDLE  = 1'b0,
        SHIFT = 1'b1
    } state_t;

    state_t state;
    reg [2:0] counter; // 3 bits to count from 4 down to 0

    // Pattern detection placeholder (no input defined in problem)
    // For now, pattern_detected is hardwired to 0.
    // Replace this with actual pattern detection logic as needed.
    wire pattern_detected = 1'b0;

    always @(posedge clk) begin
        if (reset) begin
            // On synchronous reset assert shift_ena for 4 cycles
            state    <= SHIFT;
            counter  <= 3'd4;
            shift_ena <= 1'b1;
        end else begin
            case (state)
                IDLE: begin
                    shift_ena <= 1'b0;
                    if (pattern_detected) begin
                        state    <= SHIFT;
                        counter  <= 3'd4;
                        shift_ena <= 1'b1;
                    end else begin
                        state <= IDLE;
                    end
                end

                SHIFT: begin
                    if (counter == 3'd1) begin
                        // After 4 cycles, go back to IDLE and disable shift_ena
                        state <= IDLE;
                        shift_ena <= 1'b0;
                        counter <= 3'd0;
                    end else begin
                        counter <= counter - 1;
                        shift_ena <= 1'b1;
                    end
                end

                default: begin
                    // Safety default state
                    state <= IDLE;
                    shift_ena <= 1'b0;
                    counter <= 3'd0;
                end
            endcase
        end
    end

endmodule