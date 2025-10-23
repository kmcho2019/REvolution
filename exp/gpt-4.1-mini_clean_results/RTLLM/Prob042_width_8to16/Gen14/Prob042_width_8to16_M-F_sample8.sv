module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0] stored_data;
    reg       has_stored;

    // Pipeline registers for output data and valid signal
    reg [15:0] next_data_out;
    reg        next_valid_out;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stored_data    <= 8'd0;
            has_stored     <= 1'b0;
            data_out       <= 16'd0;
            valid_out      <= 1'b0;
            next_data_out  <= 16'd0;
            next_valid_out <= 1'b0;
        end else begin
            // Register output data and valid flags from pipeline registers
            data_out  <= next_data_out;
            valid_out <= next_valid_out;

            // Default: keep pipeline registers stable (no clearing)
            // Update only when a second valid input arrives
            if (valid_in) begin
                if (!has_stored) begin
                    // Store the first valid input
                    stored_data <= data_in;
                    has_stored  <= 1'b1;
                    // No new output this cycle, keep old pipeline registers
                    // next_data_out and next_valid_out unchanged
                end else begin
                    // Second valid input arrived: prepare output for next cycle
                    next_data_out  <= {stored_data, data_in};
                    next_valid_out <= 1'b1;
                    has_stored     <= 1'b0; // Clear stored flag
                end
            end else begin
                // If no valid input, clear valid_out after outputting current data
                // Only clear next_valid_out if it was previously asserted (one cycle valid output)
                // This ensures valid_out pulse is one cycle wide
                if (next_valid_out) begin
                    next_valid_out <= 1'b0;
                    next_data_out  <= 16'd0;
                end
            end
        end
    end

endmodule