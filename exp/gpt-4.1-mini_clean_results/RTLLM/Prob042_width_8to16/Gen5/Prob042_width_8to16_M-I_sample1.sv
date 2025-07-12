module width_8to16 (
    input             clk,
    input             rst_n,
    input             valid_in,
    input      [7:0]  data_in,
    output reg        valid_out,
    output reg [15:0] data_out
);

    // State encoding
    localparam IDLE        = 1'b0;
    localparam WAIT_SECOND = 1'b1;

    reg        state;
    reg [7:0]  data_lock;       // Store first 8-bit data

    // Registers to hold outputs that are valid one cycle after second input
    reg        valid_out_next;
    reg [15:0] data_out_next;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state          <= IDLE;
            data_lock      <= 8'd0;
            data_out       <= 16'd0;
            valid_out      <= 1'b0;
            data_out_next  <= 16'd0;
            valid_out_next <= 1'b0;
        end else begin
            // Output registers update from *_next signals (1-cycle delay)
            valid_out <= valid_out_next;
            data_out  <= data_out_next;

            // Clear next-cycle output valid by default
            valid_out_next <= 1'b0;

            case (state)
                IDLE: begin
                    if (valid_in) begin
                        // Latch first byte and move to wait for second
                        data_lock <= data_in;
                        state     <= WAIT_SECOND;
                    end
                    // else remain in IDLE
                end

                WAIT_SECOND: begin
                    if (valid_in) begin
                        // Second byte arrived: prepare output for next cycle
                        data_out_next  <= {data_lock, data_in};
                        valid_out_next <= 1'b1;

                        // Go back to IDLE, ready for next data pair
                        state <= IDLE;
                    end
                    // else remain in WAIT_SECOND until second valid_in
                end

                default: begin
                    // Safety fallback to IDLE
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule