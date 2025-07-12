module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'd0,
        HIGH = 2'd1,
        LOW  = 2'd2
    } state_t;

    state_t state, next_state;

    // 2-bit shift register to track previous data_in samples
    reg [1:0] shift;

    // Update shift register on clock
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            shift <= 2'b00;
        else
            shift <= {shift[0], data_in};
    end

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE: begin
                // Wait for rising edge (0->1)
                if (data_in == 1'b1)
                    next_state = HIGH;
                else
                    next_state = IDLE;
            end

            HIGH: begin
                // Wait for falling edge (1->0)
                if (data_in == 1'b0)
                    next_state = LOW;
                else
                    next_state = HIGH;
            end

            LOW: begin
                // After pulse ends, return to IDLE if stable 0,
                // or restart pulse if data_in goes high again
                if (data_in == 1'b1)
                    next_state = HIGH;
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential state update and output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;

            // Assert data_out only on the last cycle of pulse: pattern 0->1->0 detected
            // This corresponds to state HIGH and data_in going low (detected by shift register)
            // Or more simply: when state is HIGH and next state is LOW (data_in == 0)
            // To be precise, assert data_out when we detect the falling edge of the pulse (1->0),
            // i.e. on the clock edge where state transitions from HIGH to LOW.

            // Because we update state before data_out in this always block,
            // we should rely on next_state for output logic.
            // When next_state == LOW from HIGH, data_out=1, else 0.

            data_out <= (state == HIGH) && (next_state == LOW);
        end
    end

endmodule