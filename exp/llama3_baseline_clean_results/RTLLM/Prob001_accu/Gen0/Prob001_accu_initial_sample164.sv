module accu (
    input           clk,
    input           rst_n,
    input   [7:0]   data_in,
    input           valid_in,
    output          valid_out,
    output  [9:0]   data_out
);

reg [9:0]  accu_reg;  // 10-bit register for accumulated sum
reg [1:0]  cnt_reg;   // 2-bit counter for counting valid data
reg        valid_out_reg;  // register for valid_out signal

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        accu_reg <= 10'b0;
        cnt_reg <= 2'b0;
        valid_out_reg <= 1'b0;
    end else if (valid_in) begin
        if (cnt_reg == 2'b11) begin
            // Output accumulated sum and reset counter and accumulation register
            accu_reg <= accu_reg;
            cnt_reg <= 2'b0;
            valid_out_reg <= 1'b1;
        end else begin
            // Accumulate data and increment counter
            accu_reg <= accu_reg + data_in;
            cnt_reg <= cnt_reg + 1'b1;
            valid_out_reg <= 1'b0;
        end
    end else begin
        accu_reg <= accu_reg;
        cnt_reg <= cnt_reg;
        valid_out_reg <= 1'b0;
    end
end

always @(posedge clk) begin
    if (valid_out_reg) begin
        valid_out_reg <= 1'b0;  // valid_out is only 1 for one cycle
    end
end

assign valid_out = valid_out_reg;
assign data_out = accu_reg;

endmodule