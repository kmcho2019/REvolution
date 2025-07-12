module width_8to16 (
    input          clk,
    input          rst_n,
    input          valid_in,
    input  [7:0]   data_in,
    output reg     valid_out,
    output reg [15:0] data_out
);

    // State encoding
    typedef enum logic [0:0] {
        IDLE        = 1'b0,
        WAIT_SECOND = 1'b1
    } state_t;

    state_t state, next_state;

    reg [15:0] temp_data;      // Temporary data storage, high byte stored first
    reg        output_valid_d; // Delayed valid signal for output timing

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state         <= IDLE;
            temp_data     <= 16'd0;
            valid_out     <= 1'b0;
            data_out      <= 16'd0;
            output_valid_d <= 1'b0;
        end else begin
            state <= next_state;
            output_valid_d <= 1'b0; // Default deassert unless set in next_state logic

            case (state)
                IDLE: begin
                    valid_out <= 1'b0;
                    if (valid_in) begin
                        // Store first byte at high 8 bits
                        temp_data[15:8] <= data_in;
                    end
                end
                WAIT_SECOND: begin
                    valid_out <= output_valid_d;
                    if (valid_in) begin
                        // Combine stored high byte with new low byte input
                        temp_data[7:0] <= data_in;
                        // valid_out and data_out will be updated next cycle
                    end
                end
            endcase

            // Update output registers one cycle after second valid_in
            if (output_valid_d) begin
                data_out <= temp_data;
                valid_out <= 1'b1;
            end else if (!valid_in && state == WAIT_SECOND) begin
                // Hold outputs if no second data yet
                valid_out <= 1'b0;
            end
        end
    end

    // Next state logic and output_valid_d generation
    always @(*) begin
        next_state = state;
        output_valid_d = 1'b0;

        case (state)
            IDLE: begin
                if (valid_in) begin
                    next_state = WAIT_SECOND;
                end
            end
            WAIT_SECOND: begin
                if (valid_in) begin
                    // On second valid input, prepare to output valid data next cycle
                    output_valid_d = 1'b1;
                    next_state = IDLE;
                end
                // else stay in WAIT_SECOND until second valid_in arrives
            end
        endcase
    end

endmodule