module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0] first_data;
    reg       has_first_data;
    reg [7:0] second_data;
    reg       output_pending;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            first_data      <= 8'd0;
            has_first_data  <= 1'b0;
            second_data     <= 8'd0;
            output_pending  <= 1'b0;
            data_out       <= 16'd0;
            valid_out      <= 1'b0;
        end else begin
            valid_out <= 1'b0;  // default no valid output

            if (output_pending) begin
                // Output cycle: produce concatenated data_out and assert valid_out
                data_out   <= {first_data, second_data};
                valid_out  <= 1'b1;
                output_pending <= 1'b0;

                // If new valid_in arrives during output cycle, save as first_data
                if (valid_in) begin
                    first_data     <= data_in;
                    has_first_data <= 1'b1;
                end else begin
                    has_first_data <= 1'b0;
                end
            end else begin
                // Normal cycle: capture inputs accordingly
                if (!has_first_data) begin
                    // No first data stored yet
                    if (valid_in) begin
                        first_data     <= data_in;
                        has_first_data <= 1'b1;
                    end
                end else begin
                    // Have first data, waiting for second
                    if (valid_in) begin
                        second_data    <= data_in;
                        output_pending <= 1'b1;   // output next cycle
                    end
                    // if no valid_in, stay waiting with first_data stored
                end
            end
        end
    end

endmodule