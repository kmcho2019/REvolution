module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]    i;          // shift count register (0 to 17)
    reg          done_r;
    reg [15:0]   areg;
    reg [31:0]   breg;
    reg [31:0]   yout_r;

    // Shift count register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 5'd0;
        end else if (start) begin
            if (i < 5'd17)
                i <= i + 5'd1;
            else
                i <= i; // hold at 17 until start deasserted
        end else begin
            i <= 5'd0;
        end
    end

    // Multiplication done flag update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            done_r <= 1'b0;
        else if (i == 5'd16)
            done_r <= 1'b1;
        else if (i == 5'd17 || !start)
            done_r <= 1'b0;
        else
            done_r <= done_r;
    end

    // Shift and accumulate operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg   <= 16'd0;
            breg   <= 32'd0;
            yout_r <= 32'd0;
        end else if (start) begin
            if (i == 5'd0) begin
                // Load inputs and clear accumulator
                areg   <= ain;
                breg   <= {16'd0, bin};  // zero-extend multiplier
                yout_r <= 32'd0;
            end else if (i <= 5'd16) begin
                // Accumulate partial product if current bit is 1
                if (areg[0])
                    yout_r <= yout_r + breg;
                else
                    yout_r <= yout_r;

                // Prepare for next bit
                areg <= areg >> 1;
                breg <= breg << 1;
            end else begin
                // Hold values after completion (i==17)
                areg <= areg;
                breg <= breg;
                yout_r <= yout_r;
            end
        end else begin
            // Clear registers when not started
            areg   <= 16'd0;
            breg   <= 32'd0;
            yout_r <= 32'd0;
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule