module accu(
    input           clk,
    input           rst_n,
    input   [7:0]   data_in,
    input           valid_in,
    output          valid_out,
    output  [9:0]   data_out
);

reg [9:0]   accu_reg;
reg [1:0]   cnt_reg;
reg         valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        accu_reg      <= 10'd0;
        cnt_reg       <= 2'd0;
        valid_out_reg <= 1'b0;
    end else begin
        if (valid_in) begin
            if (cnt_reg == 2'd3) begin
                // Output the accumulated sum and set valid_out to 1
                accu_reg      <= accu_reg + data_in;
                valid_out_reg <= 1'b1;
                cnt_reg       <= 2'd0; // Reset counter
            end else begin
                // Accumulate input data and increment counter
                accu_reg      <= (cnt_reg == 2'd0) ? data_in : accu_reg + data_in;
                cnt_reg       <= cnt_reg + 1'd1;
                valid_out_reg <= 1'b0;
            end
        end else begin
            // If no valid input, keep the previous state
            valid_out_reg <= 1'b0;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out  = accu_reg;

endmodule