module accu (
    input         clk, 
    input         rst_n, 
    input  [7:0]   data_in, 
    input         valid_in, 
    output        valid_out, 
    output [9:0]  data_out
);

reg [9:0] accu_sum;
reg [1:0] counter;
reg        valid_out_reg;

// Continuous assignment for output data_out
assign data_out = (valid_out) ? accu_sum : 10'd0;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        accu_sum <= 10'd0;
        counter <= 2'd0;
    end else if (valid_in) begin
        if (counter == 2'd0) begin
            accu_sum <= data_in;
        end else begin
            accu_sum <= accu_sum + data_in;
        end
        counter <= (counter == 2'd3) ? 2'd0 : counter + 1'd1;
    end else begin
        accu_sum <= accu_sum;
        counter <= counter;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        valid_out_reg <= 1'b0;
    end else begin
        if (counter == 2'd3 && valid_in) begin
            valid_out_reg <= 1'b1;
        end else if (valid_out_reg && !valid_in) begin
            valid_out_reg <= 1'b0;
        end
    end
end

assign valid_out = valid_out_reg;

endmodule