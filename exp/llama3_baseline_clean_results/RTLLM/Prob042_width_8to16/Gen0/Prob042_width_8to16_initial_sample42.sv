module width_8to16 (
    input        clk,
    input        rst_n,
    input        valid_in,
    input  [7:0] data_in,
    output       valid_out,
    output [15:0] data_out
);

reg [7:0] data_lock;
reg       flag;
reg       valid_out;
reg [15:0] data_out;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        flag          <= 1'b0;
        data_lock     <= 8'b0;
        valid_out     <= 1'b0;
        data_out      <= 16'b0;
    end else if (valid_in) begin
        if (!flag) begin
            flag      <= 1'b1;
            data_lock <= data_in;
            valid_out <= 1'b0;
        end else begin
            flag      <= 1'b0;
            valid_out <= 1'b1;
            data_out  <= {data_lock, data_in};
        end
    end else begin
        valid_out <= 1'b0;
    end
end

endmodule