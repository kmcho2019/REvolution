module multi_16bit (
    input          clk,
    input          rst_n,  // active-low reset
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output reg       done
);

    reg [4:0] i;            // shift count: 0 to 16
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] product;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i       <= 5'd0;
            areg    <= 16'd0;
            breg    <= 16'd0;
            product <= 32'd0;
            yout    <= 32'd0;
            done    <= 1'b0;
        end else begin
            if (start) begin
                if (i == 5'd0) begin
                    // Load inputs at start
                    areg    <= ain;
                    breg    <= bin;
                    product <= 32'd0;
                    done    <= 1'b0;
                    i       <= 5'd1;
                end else if (i <= 5'd16) begin
                    // Check bit (i-1) of areg, accumulate if set
                    if (areg[i-1])
                        product <= product + ( {16'd0, breg} << (i-1) );
                    else
                        product <= product;
                    i <= i + 5'd1;

                    // Assert done at i == 16
                    if (i == 5'd16)
                        done <= 1'b1;
                end else begin
                    // Hold done high after completion until start deasserted
                    done <= 1'b1;
                end
                yout <= product;
            end else begin
                // Reset when start not asserted
                i       <= 5'd0;
                areg    <= 16'd0;
                breg    <= 16'd0;
                product <= 32'd0;
                yout    <= 32'd0;
                done    <= 1'b0;
            end
        end
    end

endmodule