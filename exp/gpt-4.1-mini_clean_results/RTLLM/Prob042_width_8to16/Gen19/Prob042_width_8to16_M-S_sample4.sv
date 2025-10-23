module width_8to16 (
    input          clk,
    input          rst_n,
    input          valid_in,
    input  [7:0]   data_in,
    output         valid_out,
    output [15:0]  data_out
);

    reg        data_first_valid;     // flag indicating first data latched
    reg [7:0]  data_lock;            // store first 8-bit data

    reg        valid_out_reg;        // registered valid output
    reg [15:0] data_out_reg;         // registered 16-bit output

    // Next cycle outputs (to implement 1-cycle delay)
    reg        valid_out_next;
    reg [15:0] data_out_next;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_first_valid <= 1'b0;
            data_lock        <= 8'd0;
            valid_out_reg    <= 1'b0;
            data_out_reg     <= 16'd0;
            valid_out_next   <= 1'b0;
            data_out_next    <= 16'd0;
        end else begin
            valid_out_reg <= valid_out_next;
            data_out_reg  <= data_out_next;

            if (valid_in) begin
                if (!data_first_valid) begin
                    // First valid input: latch data_in, no output yet
                    data_lock <= data_in;
                    data_first_valid <= 1'b1;

                    valid_out_next <= 1'b0;
                    data_out_next  <= 16'd0;
                end else begin
                    // Second valid input: prepare output for next cycle
                    data_out_next  <= {data_lock, data_in};
                    valid_out_next <= 1'b1;

                    data_first_valid <= 1'b0;  // clear flag after second input
                end
            end else begin
                // No valid input, hold outputs low
                valid_out_next <= 1'b0;
                data_out_next  <= 16'd0;
            end
        end
    end

    assign valid_out = valid_out_reg;
    assign data_out  = data_out_reg;

endmodule