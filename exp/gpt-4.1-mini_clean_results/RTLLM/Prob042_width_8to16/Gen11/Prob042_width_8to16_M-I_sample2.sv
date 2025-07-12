module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    typedef enum logic [1:0] {
        WAIT_FIRST  = 2'd0,
        WAIT_SECOND = 2'd1,
        OUTPUT      = 2'd2
    } state_t;

    state_t state, next_state;

    reg [7:0] first_data;
    reg [7:0] second_data;
    reg [7:0] next_first_data;  // To hold new first data arriving during OUTPUT state
    reg       has_next_first_data;

    // State and data registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state              <= WAIT_FIRST;
            first_data         <= 8'd0;
            second_data        <= 8'd0;
            next_first_data    <= 8'd0;
            has_next_first_data <= 1'b0;
            data_out           <= 16'd0;
            valid_out          <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                WAIT_FIRST: begin
                    valid_out <= 1'b0;
                    if (valid_in) begin
                        first_data <= data_in;
                    end
                end

                WAIT_SECOND: begin
                    valid_out <= 1'b0;
                    if (valid_in) begin
                        second_data <= data_in;
                    end
                end

                OUTPUT: begin
                    // Produce output: concatenate first_data and second_data
                    data_out  <= {first_data, second_data};
                    valid_out <= 1'b1;

                    // Buffer new first data if arrives during OUTPUT cycle
                    if (valid_in) begin
                        next_first_data     <= data_in;
                        has_next_first_data <= 1'b1;
                    end else begin
                        has_next_first_data <= 1'b0;
                    end
                end

                default: begin
                    valid_out <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            WAIT_FIRST: begin
                if (valid_in)
                    next_state = WAIT_SECOND;
                else
                    next_state = WAIT_FIRST;
            end

            WAIT_SECOND: begin
                if (valid_in)
                    next_state = OUTPUT;  // second data arrived, output next cycle
                else
                    next_state = WAIT_SECOND; // wait for second data
            end

            OUTPUT: begin
                // After output, decide next state based on buffered data
                if (has_next_first_data)
                    next_state = WAIT_SECOND; // next_first_data becomes new first_data
                else
                    next_state = WAIT_FIRST;
            end

            default: next_state = WAIT_FIRST;
        endcase
    end

    // Update first_data with buffered data after OUTPUT state
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            first_data <= 8'd0;
        end else if (state == OUTPUT) begin
            if (has_next_first_data) begin
                first_data <= next_first_data;
            end
        end
    end

endmodule