module parallel2serial(
    input           clk,
    input           rst_n,
    input   [3:0]   d,
    output          valid_out,
    output          dout
);

// Internal signals
reg [3:0] data_reg;
reg [1:0] cnt_reg;
reg       valid_reg;

assign valid_out = valid_reg;
assign dout = data_reg[3];

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset logic
        data_reg <= 4'b0;
        cnt_reg <= 2'b0;
        valid_reg <= 1'b0;
    end else begin
        if (cnt_reg == 2'b11) begin
            // Last bit has been output, reset counter and load new data
            data_reg <= d;
            cnt_reg <= 2'b0;
            valid_reg <= 1'b1;
        end else begin
            // Shift data register to the right for output
            data_reg <= {data_reg[2:0], 1'b0};
            cnt_reg <= cnt_reg + 1'b1;
            if (cnt_reg == 2'b11) begin
                // All bits have been output, set valid to 0
                valid_reg <= 1'b0;
            end else begin
                valid_reg <= 1'b1;
            end
        end
    end
end

endmodule