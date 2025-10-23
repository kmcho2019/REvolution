module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    typedef enum logic [1:0] {
        IDLE = 2'b00,
        WAIT_SECOND = 2'b01,
        OUTPUT = 2'b10
    } state_t;

    state_t state, next_state;

    reg [7:0] first_byte;
    reg [15:0] output_reg;
    reg output_valid_reg;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            first_byte <= 8'd0;
            output_reg <= 16'd0;
            output_valid_reg <= 1'b0;
            valid_out <= 1'b0;
            data_out <= 16'd0;
        end else begin
            state <= next_state;

            // Register output valid and data
            valid_out <= output_valid_reg;
            data_out  <= output_reg;

            // Default clear output valid (only asserted for one cycle)
            output_valid_reg <= 1'b0;

            case(state)
                IDLE: begin
                    if (valid_in) begin
                        first_byte <= data_in;
                    end
                end
                WAIT_SECOND: begin
                    // first_byte holds first byte, wait for second
                    // output_reg and output_valid_reg set in OUTPUT state
                end
                OUTPUT: begin
                    // output_reg and valid asserted one cycle, then go to IDLE
                end
            endcase
        end
    end

    // Next state logic and output preparation
    always @(*) begin
        // Defaults
        next_state = state;
        output_reg = data_out;
        output_valid_reg = 1'b0;

        case(state)
            IDLE: begin
                if (valid_in) begin
                    next_state = WAIT_SECOND;
                end
            end
            WAIT_SECOND: begin
                if (valid_in) begin
                    // On arrival of second valid_in, prepare output in next clock
                    output_reg = {first_byte, data_in};
                    output_valid_reg = 1'b1;
                    next_state = OUTPUT;
                end else begin
                    next_state = WAIT_SECOND;
                end
            end
            OUTPUT: begin
                // Output was asserted this cycle, next return to IDLE
                next_state = IDLE;
            end
        endcase
    end

endmodule