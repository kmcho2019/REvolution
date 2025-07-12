module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding using localparams for Verilog compatibility
    localparam IDLE      = 2'b00; // Waiting for leading 0
    localparam WAIT_HIGH = 2'b01; // Leading 0 detected, waiting for 1
    localparam WAIT_LOW  = 2'b10; // Detected 1, waiting for falling edge 0 to complete pulse

    reg [1:0] current_state, next_state;

    // Sequential state and output update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            data_out <= 1'b0;
        end else begin
            current_state <= next_state;
            // Assert data_out only when transitioning from WAIT_LOW to IDLE (i.e., when pulse detected)
            // This occurs at the falling edge of the pulse completion cycle
            // To detect this, assert data_out only when current_state is WAIT_LOW and data_in is 0 (end of pulse)
            data_out <= (current_state == WAIT_LOW && data_in == 1'b0) ? 1'b1 : 1'b0;
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = current_state; // default hold state

        case (current_state)
            IDLE: begin
                if (data_in == 1'b0)
                    next_state = WAIT_HIGH; // Got leading 0, wait for rising edge
            end

            WAIT_HIGH: begin
                if (data_in == 1'b1)
                    next_state = WAIT_LOW;  // Rising edge detected, wait for falling edge
                else if (data_in == 1'b0)
                    next_state = WAIT_HIGH; // Stay in this state until rising edge
                else
                    next_state = IDLE;      // Unexpected input, reset FSM
            end

            WAIT_LOW: begin
                if (data_in == 1'b0)
                    next_state = IDLE;      // Falling edge detected, pulse complete
                else if (data_in == 1'b1)
                    next_state = WAIT_LOW;  // Still waiting for falling edge
                else
                    next_state = IDLE;      // Unexpected input, reset FSM
            end

            default: next_state = IDLE;
        endcase
    end

endmodule