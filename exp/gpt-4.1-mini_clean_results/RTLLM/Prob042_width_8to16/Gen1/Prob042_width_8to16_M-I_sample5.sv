module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    localparam WAIT_FIRST  = 1'b0;
    localparam WAIT_SECOND = 1'b1;

    reg state, next_state;
    reg [7:0] data_lock;       // Store first 8-bit data
    reg [15:0] output_reg;     // Store concatenated 16-bit output
    reg output_valid_reg;      // Registered valid_out

    // FSM state register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state           <= WAIT_FIRST;
            data_lock       <= 8'b0;
            output_reg      <= 16'b0;
            output_valid_reg <= 1'b0;
            data_out        <= 16'b0;
            valid_out       <= 1'b0;
        end else begin
            state <= next_state;

            // Default: valid_out deassert and hold data_out
            valid_out <= output_valid_reg;

            case (state)
                WAIT_FIRST: begin
                    output_valid_reg <= 1'b0; // No output valid yet
                    if (valid_in) begin
                        data_lock <= data_in;
                    end
                end

                WAIT_SECOND: begin
                    output_valid_reg <= 1'b0; // Will be set after next_state update
                    if (valid_in) begin
                        output_reg <= {data_lock, data_in};
                    end
                end
            endcase

            // Output valid and data_out update one cycle after second input
            if (state == WAIT_SECOND && next_state == WAIT_FIRST) begin
                // This transition means second data was received this cycle
                data_out        <= output_reg;
                valid_out       <= 1'b1;
                output_valid_reg <= 1'b1; // Keep valid high for this cycle
            end else begin
                // Clear output valid unless newly asserted above
                if (!(state == WAIT_SECOND && next_state == WAIT_FIRST)) begin
                    output_valid_reg <= 1'b0;
                end
            end
        end
    end

    // FSM next state logic
    always @(*) begin
        case (state)
            WAIT_FIRST: begin
                if (valid_in)
                    next_state = WAIT_SECOND;
                else
                    next_state = WAIT_FIRST;
            end

            WAIT_SECOND: begin
                if (valid_in)
                    next_state = WAIT_FIRST; // After second data received, output then wait first
                else
                    next_state = WAIT_SECOND;
            end

            default: next_state = WAIT_FIRST;
        endcase
    end

endmodule