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

    // Registers to hold output data and valid for one cycle delay after second input
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
            // Default outputs clear
            valid_out <= next_valid_out;
            data_out  <= next_data_out;
            next_valid_out <= 1'b0;
            next_data_out <= 16'd0;

            if (valid_in) begin
                if (!has_stored) begin
                    // Store first byte, no output yet
                    stored_data <= data_in;
                    has_stored  <= 1'b1;
                end else begin
                    // Second byte arrived: form output next cycle
                    next_data_out  <= {stored_data, data_in};
                    next_valid_out <= 1'b1;
                    // Clear stored flag, ready for next first byte
                    has_stored <= 1'b0;
                end
            end
        end
    end

endmodule