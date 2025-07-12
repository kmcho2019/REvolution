module width_8to16(
    input               clk,
    input               rst_n,
    input               valid_in,
    input   [7:0]       data_in,
    output              valid_out,
    output  [15:0]      data_out
);

reg [7:0]   data_lock;
reg         flag;
reg         valid_out_r;
reg [15:0] data_out_r;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        data_lock <= 8'b0;
        flag <= 1'b0;
        valid_out_r <= 1'b0;
        data_out_r <= 16'b0;
    end else begin
        if (valid_in &&!flag) begin
            data_lock <= data_in;
            flag <= 1'b1;
        end else if (valid_in && flag) begin
            data_out_r <= {data_lock, data_in};
            valid_out_r <= 1'b1;
            flag <= 1'b0;
        end else if (!valid_in && flag) begin
            // Do nothing, wait for next valid data
        end else begin
            valid_out_r <= 1'b0;
        end
    end
end

assign valid_out = valid_out_r;
assign data_out = data_out_r;

endmodule