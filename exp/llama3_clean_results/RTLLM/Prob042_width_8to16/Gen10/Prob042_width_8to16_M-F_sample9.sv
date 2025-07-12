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
                valid_out   <= 1'b0; // Reset valid_out
            end
        end
        else begin
            valid_out <= 1'b0; // Reset valid_out if no input
        end
    end
end

endmodule