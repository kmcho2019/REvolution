module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0]  data_out
);

reg [7:0] data_first; // Register to store the first 8-bit data input
reg       first_valid; // Flag to indicate if the first data is valid

always @(posedge clk) begin
    if (!rst_n) begin
        data_first     <= 8'd0;
        first_valid    <= 1'b0;
        valid_out      <= 1'b0;
        data_out       <= 16'd0;
    end
    else begin
        if (valid_in) begin
            if (first_valid) begin
                // Second data received, concatenate and output
                data_out  <= {data_first, data_in};
                valid_out <= 1'b1;
                first_valid <= 1'b0; // Reset flag
            end
            else begin
                // First data received, store it
                data_first <= data_in;
                first_valid <= 1'b1;
                valid_out   <= 1'b0; // Reset valid_out to avoid premature output
            end
        end
        else if (first_valid) begin
            // If no input and first data is valid, keep the flag and data
            first_valid <= 1'b1;
        end
        else begin
            valid_out <= 1'b0; // Reset valid_out if no input or first data is not valid
            if (!valid_in && !first_valid) begin
                // Reset data_first if no valid input and first data is not valid
                data_first <= 8'd0;
            end
        end
    end
end

endmodule