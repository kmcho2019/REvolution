module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    // State encoding
    typedef enum logic [0:0] {
        IDLE        = 1'b0,  // waiting for first data
        WAIT_SECOND = 1'b1   // waiting for second data
    } state_t;

    state_t state, next_state;

    reg [7:0] first_data;        // Holds first 8-bit input data
    reg [15:0] pipeline_data;    // Holds concatenated output data (to be registered)
    reg pipeline_valid;          // Holds valid flag for output data

    // Sequential logic: state transition and data registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state          <= IDLE;
            first_data     <= 8'b0;
            pipeline_data  <= 16'b0;
            pipeline_valid <= 1'b0;
            data_out       <= 16'b0;
            valid_out      <= 1'b0;
        end else begin
            state <= next_state;

            // Output pipeline registers update
            valid_out <= pipeline_valid;
            data_out  <= pipeline_data;

            case (state)
                IDLE: begin
                    pipeline_valid <= 1'b0; // no output yet
                    if (valid_in) begin
                        first_data <= data_in;
                    end
                end

                WAIT_SECOND: begin
                    pipeline_valid <= 1'b0; // by default clear output valid; will set below if needed
                    if (valid_in) begin
                        // Prepare concatenated data to output next cycle
                        pipeline_data  <= {first_data, data_in};
                        pipeline_valid <= 1'b1;
                    end
                end
            endcase
        end
    end

    // Combinational logic: next state logic
    always @(*) begin
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

            default: next_state = IDLE;
        endcase
    end

endmodule