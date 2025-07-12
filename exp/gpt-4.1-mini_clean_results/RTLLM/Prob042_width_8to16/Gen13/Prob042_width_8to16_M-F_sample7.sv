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

    // Registers to hold output data and valid flag for next cycle
    reg [15:0] next_data_out;
    reg        next_valid_out;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stored_data   <= 8'd0;
            has_stored    <= 1'b0;
            data_out      <= 16'd0;
            valid_out     <= 1'b0;
            next_data_out <= 16'd0;
            next_valid_out<= 1'b0;
        end else begin
            // Update output registers with previously prepared output signals
            data_out  <= next_data_out;
            valid_out <= next_valid_out;

            // Default next output signals to zero; will update below if needed
            next_data_out  <= 16'd0;
            next_valid_out <= 1'b0;

            if (valid_in) begin
                if (!has_stored) begin
                    // No stored data, save current input as first byte
                    stored_data <= data_in;
                    has_stored  <= 1'b1;
                end else begin
                    // Second byte arrived: prepare concatenated output for next cycle
                    next_data_out  <= {stored_data, data_in};
                    next_valid_out <= 1'b1;
                    // Clear stored flag to accept new first byte next
                    has_stored <= 1'b0;
                end
            end
        end
    end

endmodule