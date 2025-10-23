module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

reg [7:0] data_lock;
reg [1:0] counter;
reg       flag;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_out <= 16'd0;
        valid_out <= 1'b0;
        counter <= 2'd0;
        flag <= 1'b0;
        data_lock <= 8'd0;
    end else begin
        if (valid_in) begin
            if (!flag) begin
                data_lock <= data_in;
                flag <= 1'b1;
                counter <= counter + 1'd1;
            end else if (flag) begin
                data_out <= {data_lock, data_in};
                valid_out <= 1'b1;
                counter <= 2'd0;
                flag <= 1'b0;
            end
        end else begin
            valid_out <= 1'b0;
        end
    end
end

endmodule