module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    typedef enum reg [1:0] {
        IDLE        = 2'b00,
        HIGH_DETECTED = 2'b01,
        LOW_DETECTED  = 2'b10
    } state_t;

    state_t state, next_state;

    // FSM next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (data_in == 1'b1)
                    next_state = HIGH_DETECTED;
                else
                    next_state = IDLE;
            end

            HIGH_DETECTED: begin
                if (data_in == 1'b0)
                    next_state = LOW_DETECTED;
                else
                    next_state = HIGH_DETECTED;
            end

            LOW_DETECTED: begin
                // After detecting 0 following 1, pulse is considered detected.
                // Next state depends on data_in for next pulse detection.
                if (data_in == 1'b1)
                    next_state = HIGH_DETECTED;
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // FSM sequential logic and output generation
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // data_out is asserted only at the cycle when the FSM enters LOW_DETECTED from HIGH_DETECTED
            if (state == HIGH_DETECTED && next_state == LOW_DETECTED)
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

endmodule