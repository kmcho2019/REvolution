module width_8to16 (
    input             clk,
    input             rst_n,
    input             valid_in,
    input      [7:0]  data_in,
    output reg        valid_out,
    output reg [15:0] data_out
);

    // State encoding with localparam for synthesis friendliness
    localparam IDLE        = 1'b0;
    localparam STORE_FIRST = 1'b1;

    reg state, state_next;

    reg [7:0] data_lock;     // Stores first 8-bit input
    reg [7:0] data_in_reg;   // Stores second 8-bit input for concatenation

    // Combinational next-state logic
    always @(*) begin
        state_next = state; // default hold

        case (state)
            IDLE: begin
                if (valid_in)
                    state_next = STORE_FIRST;
                else
                    state_next = IDLE;
            end

            STORE_FIRST: begin
                if (valid_in)
                    state_next = IDLE;
                else
                    state_next = STORE_FIRST;
            end

            default: state_next = IDLE;
        endcase
    end

    // Sequential logic: state updates, data latching, and output generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state      <= IDLE;
            data_lock  <= 8'd0;
            data_in_reg <= 8'd0;
            valid_out  <= 1'b0;
            data_out   <= 16'd0;
        end else begin
            state <= state_next;

            case (state)
                IDLE: begin
                    valid_out <= 1'b0; // No valid output yet

                    if (valid_in) begin
                        data_lock <= data_in;  // Latch first byte
                    end
                end

                STORE_FIRST: begin
                    valid_out <= 1'b0; // By default no output

                    if (valid_in) begin
                        data_in_reg <= data_in; // Store second byte
                        // Outputs to be generated next cycle (one-cycle latency)
                    end

                    // After second valid_in, generate output next cycle
                    // So output valid and data should update after state transition back to IDLE
                end
            endcase

            // Output data and valid_out are produced when transitioning from STORE_FIRST to IDLE,
            // i.e. one cycle after receiving the second valid_in.
            // Detect this transition:
            if (state == STORE_FIRST && state_next == IDLE && valid_in) begin
                data_out  <= {data_lock, data_in}; // Concatenate: first data in high bits, second in low bits
                valid_out <= 1'b1;
            end else if (state == IDLE) begin
                valid_out <= 1'b0;
            end
        end
    end

endmodule