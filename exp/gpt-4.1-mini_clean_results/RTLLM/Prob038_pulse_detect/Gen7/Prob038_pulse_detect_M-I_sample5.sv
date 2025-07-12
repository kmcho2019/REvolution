module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    localparam IDLE       = 2'd0; // Waiting for initial 0 to start pulse detection
    localparam WAIT_HIGH  = 2'd1; // Got 0, waiting for 1
    localparam WAIT_LOW   = 2'd2; // Got 1 after 0, waiting for 0 (end of pulse)
    localparam PULSE_END  = 2'd3; // Pulse detected (0->1->0)

    reg [1:0] state, next_state;
    reg       next_data_out;

    // Sequential block: update state and output synchronously
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state    <= IDLE;
            data_out <= 1'b0;
        end else begin
            state    <= next_state;
            data_out <= next_data_out;
        end
    end

    // Combinational block: determine next state and output based on current state and data_in
    always @(*) begin
        // Defaults
        next_state = state;
        next_data_out = 1'b0;

        case (state)
            IDLE: begin
                // Wait for data_in=0 to start pulse detection
                if (data_in == 1'b0) begin
                    next_state = WAIT_HIGH;
                end else begin
                    next_state = IDLE;
                end
            end

            WAIT_HIGH: begin
                // Waiting for data_in=1 after initial 0
                if (data_in == 1'b1) begin
                    next_state = WAIT_LOW;
                end else if (data_in == 1'b0) begin
                    // Still 0, stay here, no pulse detected yet
                    next_state = WAIT_HIGH;
                end else begin
                    next_state = IDLE; // Defensive fallback
                end
            end

            WAIT_LOW: begin
                // Waiting for data_in=0 to complete pulse
                if (data_in == 1'b0) begin
                    next_state = PULSE_END;
                    next_data_out = 1'b1; // Assert pulse detected at end
                end else if (data_in == 1'b1) begin
                    // Data stayed high, wait for 0 again or reset pulse detection
                    next_state = WAIT_LOW;
                    next_data_out = 1'b0;
                end else begin
                    next_state = IDLE; // Defensive fallback
                end
            end

            PULSE_END: begin
                // After pulse end, wait for data_in=0 to start next pulse or 1 to go back to waiting for low
                next_data_out = 1'b0; // Output pulse is one clock only
                if (data_in == 1'b0) begin
                    next_state = WAIT_HIGH;
                end else begin
                    next_state = IDLE;
                end
            end

            default: begin
                next_state = IDLE;
                next_data_out = 1'b0;
            end
        endcase
    end

endmodule