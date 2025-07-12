module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]    i;          // shift count (0 to 16)
    reg          done_r;
    reg [15:0]   areg;
    reg [31:0]   breg_ext;   // extended multiplier shifted left progressively
    reg [31:0]   yout_r;

    wire         active;     // active multiplication phase (i in [0..16] and start asserted)
    assign active = start && (i <= 5'd16);

    // Shift count register update with clock enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 5'd0;
        end else if (!start) begin
            i <= 5'd0;
        end else if (i < 5'd16) begin
            i <= i + 5'd1;
        end
        // hold i when i == 16, waiting for done to be asserted
    end

    // Done flag update - done is asserted when i == 16
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done_r <= 1'b0;
        end else begin
            done_r <= (i == 5'd16);
        end
    end

    // Shift and accumulate operation with clock enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg    <= 16'd0;
            breg_ext <= 32'd0;
            yout_r  <= 32'd0;
        end else if (active) begin
            if (i == 5'd0) begin
                // Load inputs and clear accumulator at cycle 0
                areg    <= ain;
                breg_ext <= {16'd0, bin};
                yout_r  <= 32'd0;
            end else begin
                // Accumulate if LSB of areg is 1
                if (areg[0]) begin
                    yout_r <= yout_r + breg_ext;
                end
                // Shift registers for next bit
                areg    <= areg >> 1;
                breg_ext <= breg_ext << 1;
            end
        end else if (!start) begin
            // Reset registers when start is low
            areg    <= 16'd0;
            breg_ext <= 32'd0;
            yout_r  <= 32'd0;
        end
        // Otherwise hold registers implicitly (no else block)
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule