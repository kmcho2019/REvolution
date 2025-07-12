module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    typedef enum logic [0:0] {
        IDLE        = 1'b0,
        WAIT_SECOND = 1'b1
    } state_t;

    state_t state, next_state;

    reg [7:0] first_data_reg;
    reg [7:0] second_data_reg;

    // Output registers to hold the valid_out/data_out delayed by one cycle after second input
    reg         output_valid_reg;
    reg [15:0]  output_data_reg;

    // FSM next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if(valid_in)
                    next_state = WAIT_SECOND;
            end
            WAIT_SECOND: begin
                if(valid_in)
                    next_state = IDLE;  // after outputting concatenation, go back to IDLE or store next first_data immediately
            end
        endcase
    end

    // Sequential state transition and data path
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state           <= IDLE;
            first_data_reg  <= 8'd0;
            second_data_reg <= 8'd0;
            output_valid_reg <= 1'b0;
            output_data_reg  <= 16'd0;
            valid_out       <= 1'b0;
            data_out        <= 16'd0;
        end else begin
            state <= next_state;

            // Clear valid_out by default; will set later if output_valid_reg is set
            valid_out <= 1'b0;

            case(state)
                IDLE: begin
                    output_valid_reg <= 1'b0;  // no output yet

                    if (valid_in) begin
                        first_data_reg <= data_in; // store first data
                    end
                end
                WAIT_SECOND: begin
                    if (valid_in) begin
                        second_data_reg <= data_in; // store second data

                        // Prepare output for next cycle: concatenate first and second inputs
                        output_valid_reg <= 1'b1;
                        output_data_reg  <= {first_data_reg, data_in};

                        // For next input immediately arriving, store it as new first_data in IDLE after transition
                        // next_state = IDLE as defined in FSM logic above
                    end else begin
                        // No valid_in: keep waiting, no output yet
                        output_valid_reg <= 1'b0;
                    end
                end
            endcase

            // Generate output valid and data one cycle after second input arrival
            if (output_valid_reg) begin
                valid_out <= 1'b1;
                data_out  <= output_data_reg;
            end

            // If in WAIT_SECOND and valid_in arrives, the FSM will transit to IDLE next cycle,
            // so we need to store new first_data on next cycle:
            // This is handled by the FSM and the assignment in IDLE state above.
            if (state == WAIT_SECOND && valid_in && next_state == IDLE) begin
                // On next cycle, first_data_reg <= data_in (in IDLE state), so no special action here now.
            end
        end
    end

endmodule