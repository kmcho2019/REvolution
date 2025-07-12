module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0]  data_out
);

reg [7:0] data_first; // Register to store the first 8-bit data input
reg [7:0] data_second; // Register to store the second 8-bit data input
reg       valid_first; // Flag to indicate if the first data is valid
reg       valid_second; // Flag to indicate if the second data is valid

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_first     <= 8'd0;
        data_second    <= 8'd0;
        valid_first    <= 1'b0;
        valid_second   <= 1'b0;
        valid_out      <= 1'b0;
        data_out       <= 16'd0;
    end
    else begin
        if (valid_in && !valid_first) begin
            data_first <= data_in;
            valid_first <= 1'b1;
        end
        else if (valid_in && valid_first && !valid_second) begin
            data_second <= data_in;
            valid_second <= 1'b1;
        end
        else if (valid_first && valid_second) begin
            valid_out <= 1'b1;
            data_out <= {data_first, data_second};
            valid_first <= 1'b0;
            valid_second <= 1'b0;
        end
        else begin
            valid_out <= 1'b0;
        end
    end
end

endmodule