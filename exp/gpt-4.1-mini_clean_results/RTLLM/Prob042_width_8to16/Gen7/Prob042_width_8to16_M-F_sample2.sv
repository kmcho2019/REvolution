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
    reg [7:0]  data_lock;      // Store first 8-bit data

    reg        accept_next;    // Flag indicating ready to accept next data_in

    // Registers for output, valid_out asserted for exactly one cycle
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
            accept_next    <= 1'b1;  // Ready to accept first data after reset
        end else begin
            // Transfer next cycle outputs to outputs (one cycle latency)
            valid_out <= valid_out_next;
            data_out  <= data_out_next;

            // Default: valid_out_next deasserted unless set below
            valid_out_next <= 1'b0;

            // Handle accept_next flag: 
            // Only accept new data when valid_in is high and accept_next is 1.
            // After accepting data_in, clear accept_next to avoid re-latching.
            // When valid_in deasserts, reset accept_next to 1 to allow next data.

            if (!valid_in) begin
                // valid_in low, ready to accept new data next time valid_in goes high
                accept_next <= 1'b1;
            end else if (valid_in && accept_next) begin
                // Accept new data now
                accept_next <= 1'b0;

                case (state)
                    IDLE: begin
                        // Store first data, wait for second
                        data_lock <= data_in;
                        state     <= WAIT_SECOND;
                    end

                    WAIT_SECOND: begin
                        // Second data arrived, output concatenated data next cycle
                        data_out_next  <= {data_lock, data_in};
                        valid_out_next <= 1'b1;

                        // Go back to IDLE for next pair
                        state <= IDLE;
                    end

                    default: begin
                        // Safety fallback
                        state <= IDLE;
                    end
                endcase
            end
            // else: valid_in is high but accept_next is 0: hold current state, do not latch again
        end
    end

endmodule