module accu (
    input         clk, 
    input         rst_n, 
    input  [7:0]   data_in, 
    input         valid_in, 
    output        valid_out, 
    output [9:0]  data_out
);

reg [7:0] buffer_reg1, buffer_reg2, buffer_reg3;
reg [9:0] sum_reg;
reg [1:0] counter;
reg        valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        buffer_reg1 <= 8'd0;
        buffer_reg2 <= 8'd0;
        buffer_reg3 <= 8'd0;
        sum_reg <= 10'd0;
        counter <= 2'd0;
        valid_out_reg <= 1'b0;
    end else begin
        if (valid_in) begin
            // Pipeline stage 1: Buffering
            buffer_reg1 <= data_in;
            // Pipeline stage 2: Accumulation
            if (counter == 2'd0) begin
                sum_reg <= {2'd0, buffer_reg1};
            end else if (counter == 2'd1) begin
                sum_reg <= sum_reg + {2'd0, buffer_reg1};
            end else if (counter == 2'd2) begin
                sum_reg <= sum_reg + {2'd0, buffer_reg1};
            end else begin
                sum_reg <= sum_reg + {2'd0, buffer_reg1};
            end
            // Counter and control
            counter <= (counter == 2'd3)? 2'd0 : counter + 1'd1;
            // Output stage
            valid_out_reg <= (counter == 2'd3)? 1'b1 : 1'b0;
        end else begin
            valid_out_reg <= 1'b0;
        end
        if (valid_out_reg && ~valid_in) begin
            valid_out_reg <= 1'b0;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = (valid_out_reg)? sum_reg : 10'd0;

endmodule