module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output wire data_out
);

    // State encoding for pulse detection steps
    localparam IDLE = 2'd0;    // Waiting for initial 0
    localparam WAIT_HIGH = 2'd1; // Detected initial 0, waiting for 1
    localparam WAIT_LOW = 2'd2;  // Detected 1, waiting for falling edge 0 (end of pulse)

    reg [1:0] state, next_state;
    reg data_in_d;   // delayed data_in to detect edges
    reg pulse_out;   // registered pulse output

    // Register data_in for edge detection and state update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_in_d <= 1'b0;
            state <= IDLE;
            pulse_out <= 1'b0;
        end else begin
            data_in_d <= data_in;
            state <= next_state;
            pulse_out <= 1'b0;  // default deassert pulse output, asserted only one cycle below
        end
    end

    // Next state logic and pulse_out assertion
    always @(*) begin
        next_state = state;
        // Default pulse_out = 0; assigned in sequential block

        case (state)
            IDLE: begin
                // Wait for initial zero
                if (data_in == 1'b0)
                    next_state = WAIT_HIGH;  // Initial zero detected, wait for rising edge
                else
                    next_state = IDLE;
            end
            WAIT_HIGH: begin
                // Wait for rising edge 0->1
                if (data_in_d == 1'b0 && data_in == 1'b1)
                    next_state = WAIT_LOW;   // Rising edge detected, wait for falling edge
                else if (data_in == 1'b0) 
                    next_state = WAIT_HIGH;  // still waiting for 1, data_in stays low
                else
                    next_state = IDLE;       // Unexpected: input stuck high or no initial zero, reset FSM
            end
            WAIT_LOW: begin
                // Wait for falling edge 1->0 to complete pulse
                if (data_in_d == 1'b1 && data_in == 1'b0) begin
                    next_state = IDLE;       // Pulse complete, go back to idle
                end else if (data_in == 1'b1) begin
                    next_state = WAIT_LOW;   // Still high, wait
                end else begin
                    next_state = IDLE;       // If stuck low unexpectedly, reset
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // Output pulse_out asserted for one clock cycle at falling edge of pulse (1->0 in WAIT_LOW)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pulse_out <= 1'b0;
        end else if (state == WAIT_LOW && data_in_d == 1'b1 && data_in == 1'b0) begin
            pulse_out <= 1'b1;
        end else begin
            pulse_out <= 1'b0;
        end
    end

    assign data_out = pulse_out;

endmodule