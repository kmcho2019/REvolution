module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0] stored_data;       // Stores first 8-bit input waiting for second
    reg       stored_flag;       // Indicates if stored_data holds a valid first byte

    reg       output_valid_reg;  // Register to delay valid_out one cycle after second input
    reg [15:0] output_data_reg;  // Register to delay data_out one cycle after second input

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stored_data      <= 8'd0;
            stored_flag      <= 1'b0;
            output_valid_reg <= 1'b0;
            output_data_reg  <= 16'd0;
            valid_out       <= 1'b0;
            data_out        <= 16'd0;
        end else begin
            valid_out <= output_valid_reg;
            data_out  <= output_data_reg;

            // Default no output for next cycle
            output_valid_reg <= 1'b0;

            if (valid_in) begin
                if (!stored_flag) begin
                    // No stored data: store current input as first byte (higher bits)
                    stored_data <= data_in;
                    stored_flag <= 1'b1;
                end else begin
                    // stored_flag=1 means first byte stored, current input is second byte
                    // Prepare output data with stored_data (high) and data_in (low)
                    output_data_reg  <= {stored_data, data_in};
                    output_valid_reg <= 1'b1; // valid_out and data_out asserted next cycle
                    stored_flag      <= 1'b0; // clear stored_flag to accept new first byte next

                    // Note: stored_data can be left unchanged or overwritten next cycle if valid_in again
                end
            end
            // If no valid_in, keep stored_data and stored_flag as is (wait for next input)
        end
    end

endmodule