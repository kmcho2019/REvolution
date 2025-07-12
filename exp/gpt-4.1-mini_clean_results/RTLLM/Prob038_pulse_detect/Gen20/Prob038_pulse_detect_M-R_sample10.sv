module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output wire data_out
);

    // Declare states using enumerated type for clarity
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        WAIT_HIGH = 2'b01,
        WAIT_LOW  = 2'b10
    } state_t;

    state_t state, next_state;
    reg data_in_d;

    // Delay data_in for edge detection
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            data_in_d <= 1'b0;
        else
            data_in_d <= data_in;
    end

    // State register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic based on current state and data_in
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in == 1'b1)
                    next_state = WAIT_LOW;
                else
                    next_state = IDLE;
            end
            WAIT_LOW: begin
                if (data_in == 1'b0)
                    next_state = IDLE;
                else
                    next_state = WAIT_LOW;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic: pulse detected when data_in falls from 1 to 0 and was previously high
    assign data_out = (state == WAIT_LOW) && (data_in == 1'b0) && (data_in_d == 1'b1);

endmodule