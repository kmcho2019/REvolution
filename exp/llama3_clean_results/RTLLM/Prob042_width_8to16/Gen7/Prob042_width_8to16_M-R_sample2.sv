module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

reg [7:0] data_first; // Register to store the first 8-bit data input
reg        data_capture; // Flag to indicate if we are in the data capture state

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_first  <= 8'd0;
        data_capture <= 1'b0;
    end
    else begin
        if (valid_in) begin
            if (!data_capture) begin
                data_first  <= data_in;
                data_capture <= 1'b1;
            end
            else begin
                data_capture <= 1'b0;
            end
        end
    end
end

assign valid_out = (data_capture && valid_in);
assign data_out = (data_capture && valid_in) ? {data_first, data_in} : 16'd0;

endmodule