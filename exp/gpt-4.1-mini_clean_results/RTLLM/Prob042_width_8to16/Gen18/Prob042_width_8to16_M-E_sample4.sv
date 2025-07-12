module width_8to16 (
    input             clk,
    input             rst_n,
    input             valid_in,
    input      [7:0]  data_in,
    output reg        valid_out,
    output reg [15:0] data_out
);

    reg [7:0] buffered_data;   // Store first byte
    reg       has_first_byte;  // Flag indicating first byte stored
    reg       output_pending;  // Indicates that output is ready to be registered next cycle
    reg [15:0] next_data_out;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            buffered_data  <= 8'd0;
            has_first_byte <= 1'b0;
            data_out      <= 16'd0;
            valid_out     <= 1'b0;
            output_pending <= 1'b0;
            next_data_out  <= 16'd0;
        end else begin
            valid_out <= output_pending;
            data_out  <= next_data_out;

            if (valid_in) begin
                if (!has_first_byte) begin
                    // Capture first byte and set flag
                    buffered_data  <= data_in;
                    has_first_byte <= 1'b1;
                    output_pending <= 1'b0;  // No output yet
                end else begin
                    // Second byte arrived: prepare output for next cycle
                    next_data_out  <= {buffered_data, data_in};
                    output_pending <= 1'b1;
                    has_first_byte <= 1'b0;  // Reset for next pair
                end
            end else begin
                // No new input: clear output_pending if output was just asserted last cycle
                // Keep output_pending 0 so valid_out de-asserts next cycle
                output_pending <= 1'b0;
            end
        end
    end

endmodule