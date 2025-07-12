module accu (
    input           clk,
    input           rst_n,
    input   [7:0]   data_in,
    input           valid_in,
    output          valid_out,
    output  [9:0]   data_out
);

reg [9:0]   data_out_reg;
reg         valid_out_reg;
reg [1:0]   counter;
reg [7:0]   data_buf [0:3];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valid_out_reg <= 1'b0;
        data_out_reg  <= 10'd0;
        counter       <= 2'd0;
        data_buf      <= '{default: 8'd0};
    end else begin
        if (valid_in) begin
            data_buf[counter] <= data_in;
            if (counter == 2'd3) begin
                valid_out_reg <= 1'b1;
                data_out_reg  <= data_buf[0] + data_buf[1] + data_buf[2] + data_buf[3];
                counter       <= 2'd0;
            end else begin
                counter <= counter + 1'b1;
            end
        end else begin
            valid_out_reg <= 1'b0;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out  = data_out_reg;

endmodule