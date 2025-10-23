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
    reg [15:0]   areg;
    reg [31:0]   breg_ext;
    reg [31:0]   yout_r;

    // Shift count register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 5'd0;
        end else if (!start) begin
            i <= 5'd0;
        end else if (i < 5'd17) begin
            i <= i + 5'd1;
        end
    end

    // Done flag update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done_r <= 1'b0;
        end else if (i == 5'd16) begin
            done_r <= 1'b1;
        end else if (i == 5'd17) begin
            done_r <= 1'b0;
        end
    end

    // Shift and accumulate operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg    <= 16'd0;
            breg_ext <= 32'd0;
            yout_r  <= 32'd0;
        end else if (start) begin
            if (i == 5'd0) begin
                // Load multiplicand and multiplier, clear accumulator
                areg    <= ain;
                breg_ext <= {16'd0, bin};
                yout_r  <= 32'd0;
            end else if (i > 5'd0 && i < 5'd17) begin
                // Accumulate if LSB of areg is set
                if (areg[0])
                    yout_r <= yout_r + breg_ext;
                // Shift multiplicand right and multiplier left
                areg    <= areg >> 1;
                breg_ext <= breg_ext << 1;
            end
            // At i == 17 or other cases, hold current values implicitly by no assignment
        end else begin
            // Clear registers when start is inactive
            areg    <= 16'd0;
            breg_ext <= 32'd0;
            yout_r  <= 32'd0;
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule