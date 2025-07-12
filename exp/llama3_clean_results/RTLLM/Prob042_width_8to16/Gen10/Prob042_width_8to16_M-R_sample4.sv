module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

reg [7:0] data_first; // Register to store the first 8-bit data input
reg       first_valid; // Flag to indicate if the first data is valid
reg       valid_out_reg; // Register for valid_out
reg [15:0] data_out_reg; // Register for data_out

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_first     <= 8'd0;
        first_valid    <= 1'b0;
        valid_out_reg  <= 1'b0;
        data_out_reg   <= 16'd0;
    end
    else begin
        if (valid_in) begin
            if (first_valid) begin
                // Second data received, concatenate and output
                data_out_reg  <= {data_first, data_in};
                valid_out_reg <= 1'b1;
                first_valid   <= 1'b0; // Reset flag
            end
            else begin
                // First data received, store it
                data_first <= data_in;
                first_valid <= 1'b1;
                valid_out_reg   <= 1'b0; // Reset valid_out
            end
        end
        else begin
            valid_out_reg <= 1'b0; // Reset valid_out if no input
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule