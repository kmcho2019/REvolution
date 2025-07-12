module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0]  yout,
    output reg     done
);

    reg [4:0]    i;           // bit counter: 0 to 16
    reg [15:0]   multiplier;  // shifting multiplier
    reg [31:0]   accumulator; // accumulation of partial products

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i           <= 5'd0;
            multiplier  <= 16'd0;
            accumulator <= 32'd0;
            yout        <= 32'd0;
            done        <= 1'b0;
        end else if (start) begin
            if (i == 5'd0) begin
                // Initialize on start
                multiplier  <= bin;
                accumulator <= 32'd0;
                i           <= 5'd1;
                done        <= 1'b0;
            end else if (i <= 5'd16) begin
                // Accumulate if LSB of multiplier is 1
                if (multiplier[0])
                    accumulator <= accumulator + ( {16'd0, ain} << (i - 1) );
                else
                    accumulator <= accumulator;

                multiplier <= multiplier >> 1;
                i <= i + 5'd1;

                if (i == 5'd16)
                    done <= 1'b1;
            end else begin
                // Hold values after done
                yout <= accumulator;
            end
        end else begin
            // Reset when start is low
            i           <= 5'd0;
            multiplier  <= 16'd0;
            accumulator <= 32'd0;
            yout        <= 32'd0;
            done        <= 1'b0;
        end
    end

    // Output latch after done asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            yout <= 32'd0;
        else if (done)
            yout <= accumulator;
    end

endmodule