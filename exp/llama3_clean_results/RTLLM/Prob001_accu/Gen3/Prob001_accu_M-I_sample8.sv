module accu (
    input         clk, 
    input         rst_n, 
    input  [7:0]   data_in, 
    input         valid_in, 
    output        valid_out, 
    output [9:0]  data_out
);

reg [1:0] counter;
reg [9:0] sum_reg;
reg        valid_out_reg;
reg        clk_enable;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 2'd0;
        sum_reg <= 10'd0;
        valid_out_reg <= 1'b0;
        clk_enable <= 1'b0;
    end else begin
        if (valid_in) begin
            // Clock gating to reduce power consumption
            clk_enable <= 1'b1;
            if (counter == 2'd0) begin
                sum_reg <= {2'd0, data_in};
            end else begin
                sum_reg <= sum_reg + {2'd0, data_in};
            end
            counter <= (counter == 2'd3)? 2'd0 : counter + 1'd1;
            valid_out_reg <= (counter == 2'd3)? 1'b1 : 1'b0;
        end else begin
            valid_out_reg <= 1'b0;
            // Disable clock when not in use to reduce power consumption
            clk_enable <= 1'b0;
        end
        if (valid_out_reg && ~valid_in) begin
            valid_out_reg <= 1'b0;
        end
    end
end

// Pipelined output to improve timing performance
reg [9:0] pipeline_reg;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        pipeline_reg <= 10'd0;
    end else begin
        if (valid_out_reg) begin
            pipeline_reg <= sum_reg;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = (valid_out_reg)? pipeline_reg : 10'd0;

endmodule