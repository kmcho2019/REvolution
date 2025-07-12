module accu(
    input         clk,
    input         rst_n,
    input  [7:0]   data_in,
    input         valid_in,
    output        valid_out,
    output [9:0]  data_out
);

reg [9:0] data_out_reg;
reg       valid_out_reg;
reg [1:0] counter;
reg [9:0] sum;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        valid_out_reg <= 1'b0;
        data_out_reg <= 10'd0;
        counter <= 2'd0;
        sum <= 10'd0;
    end else begin
        valid_out_reg <= 1'b0;
        if (valid_in) begin
            if (counter < 2'd3) begin
                sum <= sum + data_in;
                counter <= counter + 1'd1;
            end else if (counter == 2'd3) begin
                sum <= sum + data_in;
                data_out_reg <= sum;
                valid_out_reg <= 1'b1;
                counter <= 2'd0;
                sum <= 10'd0;
            end
        end else begin
            counter <= 2'd0;
            sum <= 10'd0;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule