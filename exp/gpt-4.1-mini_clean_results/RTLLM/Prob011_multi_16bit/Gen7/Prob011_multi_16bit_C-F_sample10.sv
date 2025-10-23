module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]    i;           // shift count: 0 to 17
    reg          done_r;
    reg [15:0]   areg;        // multiplicand register (shifted right)
    reg [31:0]   breg_ext;    // multiplier extended and shifted left progressively
    reg [31:0]   yout_r;      // accumulator register

    // Shift count register update: count from 0 to 17 on start
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 5'd0;
        end else if (!start) begin
            i <= 5'd0;
        end else if (i < 5'd17) begin
            i <= i + 5'd1;
        end
    end

    // Done flag update: set done at i == 16, clear at i == 17 or on reset/start deassert
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done_r <= 1'b0;
        end else if (i == 5'd16) begin
            done_r <= 1'b1;
        end else if (i == 5'd17) begin
            done_r <= 1'b0;
        end else if (!start) begin
            done_r <= 1'b0;
        end
    end

    // Shift and accumulate operation: shift multiplicand right, multiplier left, accumulate partial product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg     <= 16'd0;
            breg_ext <= 32'd0;
            yout_r   <= 32'd0;
        end else if (start) begin
            if (i == 5'd0) begin
                // Load multiplicand and multiplier, clear accumulator
                areg     <= ain;
                breg_ext <= {16'd0, bin};
                yout_r   <= 32'd0;
            end else if (i > 5'd0 && i < 5'd17) begin
                // Accumulate if LSB of areg is set
                if (areg[0]) begin
                    yout_r <= yout_r + breg_ext;
                end
                // Shift multiplicand right and multiplier left for next bit
                areg     <= areg >> 1;
                breg_ext <= breg_ext << 1;
            end else begin
                // Hold registers unchanged at i == 17 or after operation ends
                areg     <= areg;
                breg_ext <= breg_ext;
                yout_r   <= yout_r;
            end
        end else begin
            // Reset registers when start is deasserted
            areg     <= 16'd0;
            breg_ext <= 32'd0;
            yout_r   <= 32'd0;
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule