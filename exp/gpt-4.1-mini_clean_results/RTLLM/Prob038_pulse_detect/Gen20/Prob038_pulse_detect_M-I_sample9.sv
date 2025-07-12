module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // Define states
    localparam IDLE = 1'b0;
    localparam HIGH = 1'b1;

    reg state, next_state;
    reg data_in_d;  // Delayed data_in to detect edges

    // Conditional sampling to reduce toggling on data_in_d register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            data_in_d <= 1'b0;
        else if (data_in == 1'b1 || state == HIGH) // sample only when relevant to pulse detection
            data_in_d <= data_in;
        // else hold previous data_in_d value, no update to reduce switching
    end

    // State register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
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
                    next_state = IDLE;
                else
                    next_state = HIGH;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic: pulse detected when data_in falls from 1 to 0 and was previously HIGH state
    always @(*) begin
        data_out = 1'b0;
        if ((state == HIGH) && (data_in == 1'b0) && (data_in_d == 1'b1))
            data_out = 1'b1;
    end

endmodule