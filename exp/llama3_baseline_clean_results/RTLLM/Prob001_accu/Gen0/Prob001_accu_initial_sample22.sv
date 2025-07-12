module accu(
    input           clk, 
    input           rst_n, 
    input   [7:0]   data_in, 
    input           valid_in, 
    output          valid_out, 
    output  [9:0]   data_out
);

reg [9:0] accu_reg;
reg [1:0] counter;
reg       valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        accu_reg    <= 10'd0;
        counter     <= 2'd0;
        valid_out_reg <= 1'b0;
    end else if (valid_in) begin
        if (counter == 2'd3) begin
            accu_reg    <= accu_reg + data_in;
            valid_out_reg <= 1'b1;
            counter     <= 2'd0;
        end else begin
            accu_reg    <= accu_reg + data_in;
            counter     <= counter + 1'd1;
            valid_out_reg <= 1'b0;
        end
    end else begin
        valid_out_reg <= 1'b0;
    end
end

always @(posedge clk) begin
    if (valid_out_reg) begin
        valid_out_reg <= 1'b0;
    end
end

assign valid_out = valid_out_reg;
assign data_out  = accu_reg;

endmodule