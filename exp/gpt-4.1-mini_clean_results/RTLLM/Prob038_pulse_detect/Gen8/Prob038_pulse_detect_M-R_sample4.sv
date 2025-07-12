module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    typedef enum logic [1:0] {
        IDLE = 2'b00,  // Waiting for data_in=0
        HIGH = 2'b01,  // Detected 0 then 1
        DONE = 2'b10   // Detected 0 after 1, pulse complete
    } state_t;

    state_t state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in == 1'b1)
                    next_state = HIGH;
                else
                    next_state = IDLE;
            end

            HIGH: begin
                if (data_in == 1'b0)
                    next_state = DONE;
                else
                    next_state = HIGH;
            end

            DONE: begin
                // After asserting pulse, go back to IDLE to detect next pulse
                if (data_in == 1'b0)
                    next_state = IDLE;
                else
                    next_state = HIGH;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state update and data_out generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // Assert data_out only at the DONE state (pulse detected)
            data_out <= (next_state == DONE);
        end
    end

endmodule