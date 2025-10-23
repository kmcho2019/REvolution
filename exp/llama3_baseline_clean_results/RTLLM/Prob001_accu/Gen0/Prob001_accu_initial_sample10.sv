module accu (
    input             clk,
    input             rst_n,
    input      [7:0]  data_in,
    input             valid_in,
    output            valid_out,
    output     [9:0]  data_out
);

reg [1:0]            counter;
reg [9:0]            accum_sum;
reg                  output_valid;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter     <= 2'd0;
        accum_sum   <= 10'd0;
        output_valid<= 1'b0;
    end else begin
        if (valid_in) begin
            accum_sum   <= accum_sum + data_in;
            counter     <= counter + 1;
        end
        
        if (counter == 4'd4) begin
            output_valid<= 1'b1;
        end else begin
            output_valid<= 1'b0;
        end
        
        if (output_valid) begin
            counter     <= 2'd0;
            accum_sum   <= 10'd0;
        end
    end
end

assign valid_out = output_valid;
assign data_out  = accum_sum;

endmodule