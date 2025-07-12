module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]    i;          // shift count (0 to 17)
    reg          done_r;
    reg [15:0]   multiplier_reg;
    reg [31:0]   product_reg;

    // Shift count register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            i <= 5'd0;
        else if (start) begin
            if (i < 5'd17)
                i <= i + 5'd1;
        end else
            i <= 5'd0;
    end

    // done flag update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            done_r <= 1'b0;
        else if (i == 5'd16)
            done_r <= 1'b1;
        else if (i == 5'd17 || !start)
            done_r <= 1'b0;
    end

    // Shift and accumulate operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplier_reg <= 16'd0;
            product_reg    <= 32'd0;
        end else if (start) begin
            if (i == 5'd0) begin
                multiplier_reg <= bin;
                product_reg    <= 32'd0;
            end else if (i >= 5'd1 && i <= 5'd16) begin
                if (multiplier_reg[0])
                    product_reg <= product_reg + (ain << (i - 1));
                else
                    product_reg <= product_reg;
                multiplier_reg <= multiplier_reg >> 1;
            end else begin
                multiplier_reg <= multiplier_reg;
                product_reg    <= product_reg;
            end
        end else begin
            multiplier_reg <= 16'd0;
            product_reg    <= 32'd0;
        end
    end

    assign yout = product_reg;
    assign done = done_r;

endmodule