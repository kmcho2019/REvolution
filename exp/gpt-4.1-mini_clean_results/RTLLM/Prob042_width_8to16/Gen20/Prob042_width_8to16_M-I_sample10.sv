module width_8to16 (
    input          clk,
    input          rst_n,
    input          valid_in,
    input  [7:0]   data_in,
    output reg     valid_out,
    output reg [15:0] data_out
);

    reg [7:0] data_lock;
    reg       flag;           // 0: waiting for first byte, 1: first byte stored, waiting for second byte
    reg       output_enable;  // Indicates that valid_out and data_out should be updated this cycle
    reg [15:0] data_out_next;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock     <= 8'd0;
            flag          <= 1'b0;
            valid_out     <= 1'b0;
            data_out      <= 16'd0;
            output_enable <= 1'b0;
            data_out_next <= 16'd0;
        end else begin
            // Default: no valid output this cycle
            valid_out <= 1'b0;
            output_enable <= 1'b0;

            if (!flag) begin
                // Waiting for first input byte
                if (valid_in) begin
                    data_lock <= data_in;
                    flag <= 1'b1;
                end
            end else begin
                // flag == 1, first byte stored, waiting for second byte
                if (valid_in) begin
                    // Concatenate stored first byte with new byte and schedule output next cycle
                    data_out_next <= {data_lock, data_in};
                    output_enable <= 1'b1;
                    flag <= 1'b0;  // Reset flag to wait for next pair
                end
            end

            // Update outputs if output_enable set (one cycle after second input arrival)
            if (output_enable) begin
                data_out <= data_out_next;
                valid_out <= 1'b1;
            end
        end
    end

endmodule