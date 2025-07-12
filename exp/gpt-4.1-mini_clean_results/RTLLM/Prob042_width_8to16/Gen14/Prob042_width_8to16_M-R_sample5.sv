module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0] first_byte;
    reg       wait_second;      // Indicates first byte stored, waiting for second
    reg       output_stage;     // Indicates output data should be generated this cycle

    reg [7:0] second_byte;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            first_byte <= 8'd0;
            second_byte <= 8'd0;
            wait_second <= 1'b0;
            output_stage <= 1'b0;
            valid_out <= 1'b0;
            data_out <= 16'd0;
        end else begin
            valid_out <= 1'b0; // Default deassert

            if (output_stage) begin
                // Output concatenated data this cycle, valid for one cycle
                data_out <= {first_byte, second_byte};
                valid_out <= 1'b1;

                // Clear flags after output
                wait_second <= 1'b0;
                output_stage <= 1'b0;
            end else if (wait_second) begin
                if (valid_in) begin
                    // Capture second byte and prepare output for next cycle
                    second_byte <= data_in;
                    output_stage <= 1'b1;
                end
                // else remain waiting for second byte
            end else begin
                // Not waiting, so check for first byte input
                if (valid_in) begin
                    first_byte <= data_in;
                    wait_second <= 1'b1;
                end
            end
        end
    end

endmodule