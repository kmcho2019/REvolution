module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]    i;          // shift count 0 to 16
    reg          done_r;
    reg [31:0]   acc;        // accumulator for the product
    reg [15:0]   multiplicand;
    reg [15:0]   multiplier;

    // Shift count register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            i <= 5'd0;
        else if (!start)
            i <= 5'd0;
        else if (i < 5'd16)
            i <= i + 5'd1;
    end

    // Done flag logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            done_r <= 1'b0;
        else if (i == 5'd16)
            done_r <= 1'b1;
        else if (i == 5'd0)
            done_r <= 1'b0;
    end

    // Shift and accumulate operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc          <= 32'd0;
            multiplicand <= 16'd0;
            multiplier   <= 16'd0;
        end else if (!start) begin
            acc          <= 32'd0;
            multiplicand <= 16'd0;
            multiplier   <= 16'd0;
        end else begin
            if (i == 5'd0) begin
                multiplicand <= ain;
                multiplier   <= bin;
                acc          <= 32'd0;
            end else if (i <= 5'd16) begin
                if (multiplier[0])
                    acc <= acc + ({16'd0, multiplicand} << (i-1));
                multiplier <= multiplier >> 1;
            end
        end
    end

    assign yout = acc;
    assign done = done_r;

endmodule