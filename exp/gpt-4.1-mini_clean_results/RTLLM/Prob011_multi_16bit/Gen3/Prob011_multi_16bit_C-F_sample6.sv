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
    reg [15:0]   areg;
    reg [31:0]   breg;       // shifted multiplier
    reg [31:0]   yout_r;

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

    // done flag update: set at i==16, clear at i==17 or !start
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
            areg   <= 16'd0;
            breg   <= 32'd0;
            yout_r <= 32'd0;
        end else if (start) begin
            if (i == 5'd0) begin
                // Load multiplicand and multiplier, clear accumulator
                areg   <= ain;
                breg   <= {16'd0, bin}; // zero-extend multiplier
                yout_r <= 32'd0;
            end else if (i >= 5'd1 && i <= 5'd16) begin
                // If LSB of areg is 1, accumulate shifted multiplier
                if (areg[0])
                    yout_r <= yout_r + breg;
                else
                    yout_r <= yout_r;

                // Shift areg right for next bit
                areg <= areg >> 1;
                // Shift breg left to align with next bit position
                breg <= breg << 1;
            end else begin
                // Hold registers stable when i == 17 or beyond
                areg   <= areg;
                breg   <= breg;
                yout_r <= yout_r;
            end
        end else begin
            // When start is low, reset registers
            areg   <= 16'd0;
            breg   <= 32'd0;
            yout_r <= 32'd0;
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule