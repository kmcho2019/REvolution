module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    typedef enum logic [0:0] {
        IDLE = 1'b0,
        WAIT_SECOND = 1'b1
    } state_t;

    state_t current_state, next_state;

    reg [7:0] first_byte;
    reg [15:0] output_reg;
    reg        output_valid_reg;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic and input capture
    always @(*) begin
        next_state = current_state;
        case (current_state)
            IDLE: begin
                if (valid_in)
                    next_state = WAIT_SECOND;
            end
            WAIT_SECOND: begin
                if (valid_in)
                    next_state = IDLE;
            end
        endcase
    end

    // Data registers and output generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            first_byte       <= 8'd0;
            output_reg       <= 16'd0;
            output_valid_reg <= 1'b0;
            valid_out        <= 1'b0;
            data_out         <= 16'd0;
        end else begin
            output_valid_reg <= 1'b0;  // default: no output valid this cycle

            case (current_state)
                IDLE: begin
                    if (valid_in) begin
                        first_byte <= data_in;
                    end
                end
                WAIT_SECOND: begin
                    if (valid_in) begin
                        // Concatenate first_byte (high) and data_in (low)
                        output_reg       <= {first_byte, data_in};
                        output_valid_reg <= 1'b1;
                    end
                end
            endcase

            // Register output data and valid one cycle after second input
            valid_out <= output_valid_reg;
            data_out  <= output_reg;
        end
    end

endmodule