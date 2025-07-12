module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'd0,  // waiting for data_in=1
        HIGH = 2'd1,  // data_in=1 detected
        LOW  = 2'd2   // data_in=0 after high, pulse end
    } state_t;

    state_t state, next_state;

    // Next state logic and output
    always @(*) begin
        data_out = 1'b0; // default output

        case(state)
            IDLE: begin
                if (data_in)
                    next_state = HIGH;
                else
                    next_state = IDLE;
            end

            HIGH: begin
                if (~data_in)
                    next_state = LOW;
                else
                    next_state = HIGH;
            end

            LOW: begin
                // data_in must stay low to confirm pulse end
                // Output pulse detection here, then back to IDLE
                data_out = 1'b1;
                if (data_in)
                    next_state = HIGH;
                else
                    next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // data_out updated combinationally, so latch output here
            if (state == LOW)
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

endmodule