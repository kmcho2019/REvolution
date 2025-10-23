module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    localparam IDLE   = 2'b00; // Waiting for first 0
    localparam WAIT_1 = 2'b01; // Detected 0, waiting for 1
    localparam WAIT_0 = 2'b10; // Detected 1, waiting for 0 (end of pulse)

    reg [1:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE: begin
                // Wait for data_in=0 to start detection
                if (data_in == 1'b0)
                    next_state = WAIT_1;
                else
                    next_state = IDLE;
            end

            WAIT_1: begin
                // Waiting for data_in=1 to continue pulse
                if (data_in == 1'b1)
                    next_state = WAIT_0;
                else if (data_in == 1'b0)
                    // Still 0, remain in WAIT_1 waiting for 1
                    next_state = WAIT_1;
                else
                    next_state = IDLE; // fallback
            end

            WAIT_0: begin
                // Waiting for data_in=0 to detect pulse end
                if (data_in == 1'b0)
                    next_state = WAIT_1; // after pulse, ready for next 0->1->0
                else if (data_in == 1'b1)
                    next_state = WAIT_0; // still 1, wait for 0
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Output logic and state update
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // data_out = 1 when sequence 0->1->0 is detected at the last 0 (WAIT_0 state sees data_in=0)
            if (state == WAIT_0 && data_in == 1'b0)
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

endmodule