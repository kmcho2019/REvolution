module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE        = 2'b00,
        WAIT_HIGH   = 2'b01,
        WAIT_LOW    = 2'b10,
        PULSE_DET   = 2'b11
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if(data_in == 1'b0)
                    next_state = WAIT_HIGH;  // detected initial 0, wait for 1
                else
                    next_state = IDLE;
            end
            WAIT_HIGH: begin
                if(data_in == 1'b1)
                    next_state = WAIT_LOW;   // got 1 after 0
                else if(data_in == 1'b0)
                    next_state = WAIT_HIGH;  // stay waiting for 1
                else
                    next_state = IDLE;
            end
            WAIT_LOW: begin
                if(data_in == 1'b0)
                    next_state = PULSE_DET; // got 0 after 1: pulse detected
                else if(data_in == 1'b1)
                    next_state = WAIT_LOW;   // keep waiting for 0
                else
                    next_state = IDLE;
            end
            PULSE_DET: begin
                // After pulse detection, go back to IDLE or WAIT_HIGH depending on input
                if(data_in == 1'b0)
                    next_state = WAIT_HIGH; // ready to detect next pulse
                else
                    next_state = IDLE;      // wait for 0 again
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state update and output generation
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            if(next_state == PULSE_DET)
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

endmodule