module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    typedef enum reg [1:0] {
        IDLE = 2'b00,
        HIGH = 2'b01,
        WAIT_FOR_FALL = 2'b10
    } state_t;

    reg [1:0] current_state, next_state;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
            current_state <= IDLE;
        else 
            current_state <= next_state;
    end

    // Next state logic and output logic
    always @(*) begin
        data_out = 1'b0;  // Default output
        case (current_state)
            IDLE: begin
                if (data_in == 1'b1)
                    next_state = HIGH;
                else
                    next_state = IDLE;
            end
            HIGH: begin
                if (data_in == 1'b1)
                    next_state = HIGH;    // Stay if still high (pulse longer than 1 cycle)
                else if (data_in == 1'b0)
                    next_state = WAIT_FOR_FALL;
                else
                    next_state = IDLE;    // Fallback
            end
            WAIT_FOR_FALL: begin
                // The pattern 0->1->0 detected at this cycle (falling edge after a high)
                data_out = 1'b1;
                if (data_in == 1'b0)
                    next_state = IDLE;
                else
                    next_state = HIGH;    // If glitch back high, restart pulse
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule