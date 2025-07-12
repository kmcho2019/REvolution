module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output          valid_out,
    output [15:0]   data_out
);

    // Define FSM states
    typedef enum logic [0:0] {
        IDLE = 1'b0,
        WAIT_SECOND = 1'b1
    } state_t;

    state_t state, next_state;

    reg [7:0] first_byte;
    reg [15:0] output_data_reg;
    reg valid_out_reg;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state and output logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (valid_in)
                    next_state = WAIT_SECOND;
                else
                    next_state = IDLE;
            end
            WAIT_SECOND: begin
                if (valid_in)
                    next_state = IDLE;
                else
                    next_state = WAIT_SECOND;
            end
        endcase
    end

    // Data storage and output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            first_byte     <= 8'd0;
            output_data_reg <= 16'd0;
            valid_out_reg   <= 1'b0;
        end else begin
            valid_out_reg <= 1'b0; // Default no valid output

            case (state)
                IDLE: begin
                    if (valid_in) begin
                        first_byte <= data_in; // Store first byte
                    end
                end
                WAIT_SECOND: begin
                    if (valid_in) begin
                        // Concatenate first_byte (high bits) and current data_in (low bits)
                        output_data_reg <= {first_byte, data_in};
                        valid_out_reg   <= 1'b1; // Output valid next clock cycle
                    end
                end
            endcase
        end
    end

    assign valid_out = valid_out_reg;
    assign data_out  = output_data_reg;

endmodule