module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg         flag_first;      // Indicates if first byte is stored
    reg  [7:0]  first_byte;

    reg         valid_out_d;     // Pipeline registers to delay output by one cycle
    reg  [15:0] data_out_d;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            flag_first  <= 1'b0;
            first_byte  <= 8'd0;
            valid_out   <= 1'b0;
            data_out    <= 16'd0;
            valid_out_d <= 1'b0;
            data_out_d  <= 16'd0;
        end else begin
            if (valid_in) begin
                if (!flag_first) begin
                    // Store first byte, set flag
                    first_byte <= data_in;
                    flag_first <= 1'b1;
                    // No output yet
                    valid_out_d <= 1'b0;
                end else begin
                    // Second byte received: concatenate and generate output next cycle
                    data_out_d  <= {first_byte, data_in};
                    valid_out_d <= 1'b1;
                    flag_first  <= 1'b0;
                end
            end else begin
                // No valid input: hold outputs low
                valid_out_d <= 1'b0;
            end

            // Register outputs delayed by one cycle
            valid_out <= valid_out_d;
            data_out  <= data_out_d;
        end
    end

endmodule