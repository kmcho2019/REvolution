module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

reg [7:0] data_lock;
reg [15:0] data_out_reg;
reg       valid_out_reg;

always @(posedge clk) begin
    if (!rst_n) begin
        data_lock      <= 8'd0;
        data_out_reg   <= 16'd0;
        valid_out_reg  <= 1'b0;
    end
    else begin
        if (valid_in) begin
            if (data_lock == 8'd0) begin
                data_lock      <= data_in;
            end
            else begin
                data_out_reg   <= {data_lock, data_in};
                valid_out_reg  <= 1'b1;
                data_lock      <= 8'd0;
            end
        end
        else begin
            valid_out_reg  <= 1'b0;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out  = data_out_reg;

endmodule