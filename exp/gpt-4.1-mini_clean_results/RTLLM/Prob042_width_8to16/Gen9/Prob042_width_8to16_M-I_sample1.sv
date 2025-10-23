module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    // State encoding
    localparam IDLE        = 1'b0;
    localparam WAIT_SECOND = 1'b1;

    reg state, next_state;

    reg [7:0] data_lock;       // Store first 8-bit input
    reg [7:0] data_second;     // Store second 8-bit input

    reg output_stage;          // Indicates output cycle after second data received

    // Sequential logic: state and data registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= IDLE;
            data_lock   <= 8'd0;
            data_second <= 8'd0;
            data_out    <= 16'd0;
            valid_out   <= 1'b0;
            output_stage <= 1'b0;
        end else begin
            state <= next_state;

            // Default outputs
            valid_out <= 1'b0;

            if (output_stage) begin
                // Output concatenated data one cycle after second input
                data_out  <= {data_lock, data_second};
                valid_out <= 1'b1;

                // If valid_in arrives during output cycle, treat as new first input
                if (valid_in) begin
                    data_lock <= data_in;
                    data_second <= 8'd0; // clear second data until next input
                end

                output_stage <= 1'b0; // clear output stage after output
            end else begin
                // During non-output cycles, latch inputs according to state
                case(state)
                    IDLE: begin
                        if (valid_in) begin
                            data_lock <= data_in; // latch first input
                        end
                    end
                    WAIT_SECOND: begin
                        if (valid_in) begin
                            data_second <= data_in; // latch second input
                        end
                    end
                endcase
            end
        end
    end

    // Combinational next state and output_stage logic
    always @(*) begin
        next_state = state;
        output_stage = 1'b0;

        case(state)
            IDLE: begin
                if (valid_in)
                    next_state = WAIT_SECOND;
                else
                    next_state = IDLE;
            end

            WAIT_SECOND: begin
                if (valid_in) begin
                    // Second input received, output next cycle
                    next_state = IDLE;
                    output_stage = 1'b1;
                end else
                    next_state = WAIT_SECOND;
            end
        endcase
    end

endmodule