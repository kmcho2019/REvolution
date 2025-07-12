module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    typedef enum logic [1:0] {
        IDLE = 2'd0,  // Waiting for data_in to be 0 (initial condition)
        HIGH = 2'd1,  // Detected rising edge: data_in went from 0 to 1
        DONE = 2'd2   // Pulse detected (0->1->0), output pulse one cycle
    } state_t;

    state_t current_state, next_state;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Next state logic and output logic
    always @(*) begin
        // Default assignments
        next_state = current_state;
        data_out = 1'b0;

        case (current_state)
            IDLE: begin
                if (data_in == 1'b1)
                    next_state = HIGH;
            end
            HIGH: begin
                if (data_in == 1'b0) begin
                    next_state = DONE;
                    data_out = 1'b1; // Pulse detected here
                end
                else if (data_in == 1'b1) begin
                    // Stay in HIGH while data_in remains 1
                    next_state = HIGH;
                end
            end
            DONE: begin
                next_state = IDLE;  // Go back to IDLE after pulse detected
                data_out = 1'b0;    // Output pulse is only one cycle
            end
            default: begin
                next_state = IDLE;
                data_out = 1'b0;
            end
        endcase
    end

endmodule