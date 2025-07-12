module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output reg      done
);

    reg [4:0] count;
    reg [31:0] product;
    reg [15:0] multiplicand;
    reg [15:0] multiplier;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count        <= 5'd0;
            product      <= 32'd0;
            multiplicand <= 16'd0;
            multiplier   <= 16'd0;
            yout         <= 32'd0;
            done         <= 1'b0;
        end else begin
            if (count == 0) begin
                done <= 1'b0;
                if (start) begin
                    multiplicand <= ain;
                    multiplier   <= bin;
                    product      <= 32'd0;
                    count        <= 5'd1;
                end
            end else if (count <= 16) begin
                if (multiplier[0]) begin
                    product <= product + ( {16'd0, multiplicand} << (count - 1) );
                end
                multiplier <= multiplier >> 1;
                count <= count + 1'b1;
                if (count == 16) begin
                    yout <= product;
                    done <= 1'b1;
                end
            end else begin
                // Wait for start to go low to reset count
                if (!start) begin
                    count <= 5'd0;
                end
            end
        end
    end

endmodule