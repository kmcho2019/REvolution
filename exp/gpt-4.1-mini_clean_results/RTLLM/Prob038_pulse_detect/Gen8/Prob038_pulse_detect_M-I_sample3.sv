module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE        = 2'b00,
        WAIT_FALL   = 2'b01,
        PULSE_DETECTED = 2'b10
    } state_t;

    state_t state, next_state;
    reg data_in_d;  // delayed version of data_in for edge detection

    // Synchronize data_in and detect edges
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_in_d <= 1'b0;
        end else begin
            data_in_d <= data_in;
        end
    end

    wire rising_edge  = (data_in == 1'b1) && (data_in_d == 1'b0);
    wire falling_edge = (data_in == 1'b0) && (data_in_d == 1'b1);

    // FSM sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;

            // data_out is asserted only in PULSE_DETECTED state for one cycle
            if (next_state == PULSE_DETECTED)
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

    // FSM combinational logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (rising_edge) 
                    next_state = WAIT_FALL;
                else
                    next_state = IDLE;
            end

            WAIT_FALL: begin
                if (falling_edge)
                    next_state = PULSE_DETECTED;
                else
                    next_state = WAIT_FALL;
            end

            PULSE_DETECTED: begin
                // After pulse detected, return to IDLE
                next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule