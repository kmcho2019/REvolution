module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    typedef enum reg [1:0] {
        IDLE      = 2'b00, // waiting for 0
        WAIT_HIGH = 2'b01, // detected rising edge, waiting for high
        WAIT_LOW  = 2'b10  // detected 1, waiting for falling edge back to 0
    } state_t;

    state_t state, next_state;

    // Next state logic and output generation
    always @(*) begin
        data_out = 1'b0;  // default output
        case (state)
            IDLE: begin
                if (data_in == 1'b1)
                    next_state = WAIT_HIGH;
                else
                    next_state = IDLE;
            end

            WAIT_HIGH: begin
                if (data_in == 1'b1)
                    next_state = WAIT_LOW; // remain high for 1 cycle, then expect low
                else
                    next_state = IDLE; // if goes back to 0 before high stable, reset
            end

            WAIT_LOW: begin
                if (data_in == 1'b0) begin
                    next_state = IDLE;
                    data_out = 1'b1; // pulse detected at this cycle
                end else
                    next_state = WAIT_LOW; // still high, wait for falling edge
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential state update
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state    <= IDLE;
            data_out <= 1'b0;
        end else begin
            state    <= next_state;
            // data_out already assigned combinationally
            // but to register one cycle pulse, re-assign here
            if (state == WAIT_LOW && data_in == 1'b0)
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

endmodule