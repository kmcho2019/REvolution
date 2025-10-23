module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'b00,   // Waiting for rising edge (data_in=1)
        HIGH = 2'b01,   // data_in=1 detected, waiting for falling edge
        DONE = 2'b10    // Pulse detected; data_out asserted this cycle
    } state_t;

    state_t state, next_state;

    // State transition and output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // data_out is 1 only in DONE state, else 0
            data_out <= (next_state == DONE) ? 1'b1 : 1'b0;
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in)
                    next_state = HIGH;
                else
                    next_state = IDLE;
            end
            HIGH: begin
                if (!data_in)
                    next_state = DONE;
                else
                    next_state = HIGH;
            end
            DONE: begin
                // After pulse indication, go back to IDLE waiting for next pulse
                if (data_in)
                    next_state = HIGH; // New pulse starting immediately
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule