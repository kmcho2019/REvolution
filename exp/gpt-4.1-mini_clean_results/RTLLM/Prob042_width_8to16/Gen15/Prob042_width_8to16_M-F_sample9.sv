module width_8to16 (
    input          clk,
    input          rst_n,
    input          valid_in,
    input  [7:0]   data_in,
    output         valid_out,
    output [15:0]  data_out
);

    // State encoding
    localparam IDLE        = 1'b0;
    localparam WAIT_SECOND = 1'b1;

    reg         state, next_state;

    reg [7:0]   first_data;      // store first 8-bit data
    reg [7:0]   second_data;     // store second 8-bit data

    reg         valid_out_reg;
    reg [15:0]  data_out_reg;

    // FSM sequential block
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state         <= IDLE;
            first_data    <= 8'd0;
            second_data   <= 8'd0;
            valid_out_reg <= 1'b0;
            data_out_reg  <= 16'd0;
        end else begin
            state <= next_state;

            valid_out_reg <= 1'b0;  // default deassert valid_out each cycle

            case (state)
                IDLE: begin
                    if (valid_in) begin
                        first_data <= data_in;
                    end
                end

                WAIT_SECOND: begin
                    if (valid_in) begin
                        second_data <= data_in;
                        // valid_out and data_out will be updated in next state cycle (IDLE)
                    end
                end

                default: ;
            endcase

            // Output logic: valid_out and data_out are registered when returning to IDLE after second input
            if (state == WAIT_SECOND && next_state == IDLE && valid_in) begin
                // Concatenate stored first_data and second_data (second_data just captured this cycle)
                data_out_reg  <= {first_data, data_in};
                valid_out_reg <= 1'b1;
            end
        end
    end

    // FSM combinational next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (valid_in)
                    next_state = WAIT_SECOND;
                else
                    next_state = IDLE;
            end
            WAIT_SECOND: begin
                if (valid_in)
                    next_state = IDLE; // After second data, return to IDLE
                else
                    next_state = WAIT_SECOND; // Wait for second valid input
            end
            default: next_state = IDLE;
        endcase
    end

    assign valid_out = valid_out_reg;
    assign data_out  = data_out_reg;

endmodule