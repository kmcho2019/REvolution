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
reg       output_valid; // Flag to indicate if output is valid
reg [15:0] output_data; // Register to hold the concatenated data

// Sequential Logic for State Machine and Data Storage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_first    <= 8'd0;
        first_valid   <= 1'b0;
        output_valid  <= 1'b0;
        output_data   <= 16'd0;
    end
    else begin
        if (valid_in) begin
            if (!first_valid) begin
                data_first <= data_in;
                first_valid <= 1'b1;
            end
            else begin
                output_data <= {data_first, data_in};
                output_valid <= 1'b1;
                first_valid <= 1'b0;
            end
        end
        else begin
            output_valid <= 1'b0;
        end
    end
end

// Combinational Logic for Output
assign valid_out = output_valid;
assign data_out = output_data;

endmodule