module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE        = 2'b00,
        WAIT_SECOND = 2'b01
    } state_t;

    state_t current_state, next_state;

    reg [7:0] stored_data;

    // FSM sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            stored_data   <= 8'd0;
            data_out      <= 16'd0;
            valid_out     <= 1'b0;
        end else begin
            current_state <= next_state;

            case (current_state)
                IDLE: begin
                    valid_out <= 1'b0;  // No valid output in IDLE
                    if (valid_in) begin
                        stored_data <= data_in;
                    end
                end

                WAIT_SECOND: begin
                    // valid_out and data_out are registered when second valid_in is detected
                    if (valid_in) begin
                        data_out  <= {stored_data, data_in};
                        valid_out <= 1'b1;
                    end else begin
                        // If no second data arrives, deassert valid_out and keep data_out unchanged
                        valid_out <= 1'b0;
                    end
                end
            endcase
        end
    end

    // FSM combinational next state logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (valid_in)
                    next_state = WAIT_SECOND;
                else
                    next_state = IDLE;
            end

            WAIT_SECOND: begin
                if (valid_in)
                    next_state = IDLE;  // After outputting, go back to IDLE to accept new pair
                else
                    next_state = WAIT_SECOND; // Wait until second data arrives
            end

            default: next_state = IDLE;
        endcase
    end

endmodule