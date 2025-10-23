module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0] first_data;
    reg [7:0] second_data;

    reg waiting_second;   // 0: waiting for first input; 1: first input stored, waiting second input
    reg output_ready;     // indicates concatenated data ready to output next cycle

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            first_data     <= 8'd0;
            second_data    <= 8'd0;
            waiting_second <= 1'b0;
            output_ready   <= 1'b0;
            valid_out      <= 1'b0;
            data_out       <= 16'd0;
        end else begin
            valid_out <= 1'b0;  // Default no valid output

            if (output_ready) begin
                // Output concatenated data one cycle after second input
                data_out  <= {first_data, second_data};
                valid_out <= 1'b1;

                // Clear output_ready and waiting_second after output
                output_ready   <= 1'b0;
                waiting_second <= 1'b0;
            end else begin
                if (valid_in) begin
                    if (!waiting_second) begin
                        // Store first data and set flag to wait for second
                        first_data     <= data_in;
                        waiting_second <= 1'b1;
                    end else begin
                        // Store second data and prepare for output next cycle
                        second_data  <= data_in;
                        output_ready <= 1'b1;
                    end
                end
                // If valid_in == 0 and no output_ready, hold states and do nothing
            end
        end
    end

endmodule