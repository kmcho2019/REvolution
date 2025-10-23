module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

reg [7:0] data_first; // Register to store the first 8-bit data input
reg [7:0] data_second; // Register to store the second 8-bit data input
reg       valid_first; // Flag to indicate when the first valid data input has arrived

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_first   <= 8'd0;
        data_second <= 8'd0;
        valid_first <= 1'd0;
    end
    else begin
        if (valid_in) begin
            if (!valid_first) begin
                data_first   <= data_in;
                valid_first <= 1'd1;
            end
            else begin
                data_second <= data_in;
            end
        end
        else begin
            valid_first <= 1'd0;
        end
    end
end

assign valid_out = (valid_first && valid_in);
assign data_out  = (valid_out)? {data_first, data_second} : 16'd0;

endmodule