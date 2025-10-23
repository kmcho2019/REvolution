module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0] data_lock;
    reg       has_data;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock  <= 8'd0;
            has_data   <= 1'b0;
            valid_out  <= 1'b0;
            data_out   <= 16'd0;
        end else begin
            valid_out <= 1'b0;  // Default no valid output

            if (valid_in) begin
                if (!has_data) begin
                    // First valid input: store data and wait for next input
                    data_lock <= data_in;
                    has_data  <= 1'b1;
                end else begin
                    // Second valid input: output concatenation and clear flag
                    data_out  <= {data_lock, data_in};
                    valid_out <= 1'b1;
                    has_data  <= 1'b0;
                end
            end
            // If valid_in is low, do nothing; valid_out stays 0
            // has_data remains unchanged to wait for second data
        end
    end

endmodule