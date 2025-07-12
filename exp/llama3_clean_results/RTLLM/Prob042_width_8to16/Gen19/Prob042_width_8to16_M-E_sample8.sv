module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

reg [7:0] first_data;
reg [7:0] second_data;
reg       first_data_valid;
reg       second_data_valid;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        first_data <= 8'd0;
        second_data <= 8'd0;
        first_data_valid <= 1'b0;
        second_data_valid <= 1'b0;
    end
    else begin
        if (valid_in) begin
            if (!first_data_valid) begin
                first_data <= data_in;
                first_data_valid <= 1'b1;
            end
            else if (!second_data_valid) begin
                second_data <= data_in;
                second_data_valid <= 1'b1;
            end
        end
        else begin
            // Reset second data valid flag when input is not valid
            second_data_valid <= 1'b0;
        end
    end
end

assign valid_out = first_data_valid && second_data_valid;
assign data_out = {first_data, second_data};

endmodule