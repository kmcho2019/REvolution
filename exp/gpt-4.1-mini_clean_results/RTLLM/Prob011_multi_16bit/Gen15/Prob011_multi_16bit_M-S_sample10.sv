module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]    count;     // Counts 0 to 16
    reg [31:0]   product;
    reg          done_r;
    reg [15:0]   multiplicand;
    reg [15:0]   multiplier;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count        <= 5'd0;
            product      <= 32'd0;
            multiplicand <= 16'd0;
            multiplier   <= 16'd0;
            done_r       <= 1'b0;
        end else if (start) begin
            if (count == 5'd0) begin
                multiplicand <= ain;
                multiplier   <= bin;
                product      <= 32'd0;
                count        <= 5'd1;
                done_r       <= 1'b0;
            end else if (count <= 5'd16) begin
                if (multiplier[0])
                    product <= product + (multiplicand << (count - 1));
                count <= count + 5'd1;
                if (count == 5'd16)
                    done_r <= 1'b1;
            end
        end else begin
            count        <= 5'd0;
            product      <= product; // hold value
            multiplicand <= multiplicand;
            multiplier   <= multiplier;
            done_r       <= 1'b0;
        end
    end

    assign yout = product;
    assign done = done_r;

endmodule