module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output valid_out,
    output [15:0] data_out
);

reg [7:0] locked_data;
reg [15:0] output_data;
reg valid_output;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        locked_data <= 8'b0;
        output_data <= 16'b0;
        valid_output <= 1'b0;
    end else begin
        valid_output <= 1'b0;
        if (valid_in) begin
            if (locked_data == 8'b0) begin
                locked_data <= data_in;
            end else begin
                output_data <= {locked_data, data_in};
                valid_output <= 1'b1;
                locked_data <= 8'b0;
            end
        end
    end
end

assign valid_out = valid_output;
assign data_out = output_data;

endmodule