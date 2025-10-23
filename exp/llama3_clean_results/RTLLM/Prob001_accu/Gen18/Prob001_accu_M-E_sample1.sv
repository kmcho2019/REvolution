module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [31:0] shift_reg;
reg [9:0] sum1, sum2, final_sum;
reg valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 32'd0;
        sum1 <= 10'd0;
        sum2 <= 10'd0;
        final_sum <= 10'd0;
        valid_out_reg <= 1'b0;
    end else begin
        if (valid_in) begin
            // Shift register logic
            shift_reg <= {shift_reg[23:0], data_in};
            
            // Compute sums
            sum1 <= shift_reg[7:0] + shift_reg[15:8];
            sum2 <= shift_reg[23:16] + shift_reg[31:24];
        end
        
        // Pipeline stage 1: compute intermediate sums
        if (shift_reg[31] == 1'b1) begin
            final_sum <= sum1 + sum2;
            valid_out_reg <= 1'b1;
        end else begin
            final_sum <= 10'd0;
            valid_out_reg <= 1'b0;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = final_sum;

endmodule