module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]    i;         // shift count (0 to 17)
    reg          done_r;
    reg [31:0]   areg;      // shifted multiplicand
    reg [15:0]   breg;      // shifting multiplier
    reg [31:0]   yout_r;    // accumulator

    // Shift count control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            i <= 5'd0;
        else if (!start)
            i <= 5'd0;
        else if (i < 5'd17)
            i <= i + 5'd1;
    end

    // Done flag control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            done_r <= 1'b0;
        else if (i == 5'd16)
            done_r <= 1'b1;
        else if (i == 5'd17)
            done_r <= 1'b0;
    end

    // Shift and accumulate logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg   <= 32'd0;
            breg   <= 16'd0;
            yout_r <= 32'd0;
        end else if (!start) begin
            areg   <= 32'd0;
            breg   <= 16'd0;
            yout_r <= 32'd0;
        end else begin
            if (i == 5'd0) begin
                // Load multiplicand in areg (lower 16 bits), multiplier in breg, clear accumulator
                areg   <= {16'd0, ain};
                breg   <= bin;
                yout_r <= 32'd0;
            end else if (i <= 5'd16) begin
                // If LSB of breg is 1, add areg to yout_r
                if (breg[0])
                    yout_r <= yout_r + areg;
                // Shift areg left by 1 (equivalent to multiplicand * 2^(i))
                areg <= areg << 1;
                // Shift breg right by 1 to process next multiplier bit
                breg <= breg >> 1;
            end
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule