module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]    i;        // shift count: 0 to 17
    reg          done_r;
    reg [15:0]   areg;     // multiplicand register (shifted right)
    reg [31:0]   breg;     // multiplier register zero-extended and shifted left
    reg [31:0]   yout_r;   // product accumulator

    // Shift count register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            i <= 5'd0;
        else if (!start)
            i <= 5'd0;
        else if (i < 5'd17)
            i <= i + 5'd1;
    end

    // Done flag update
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
            areg   <= 16'd0;
            breg   <= 32'd0;
            yout_r <= 32'd0;
        end else if (!start) begin
            areg   <= 16'd0;
            breg   <= 32'd0;
            yout_r <= 32'd0;
        end else begin
            if (i == 5'd0) begin
                // Load registers
                areg   <= ain;
                breg   <= {16'd0, bin};
                yout_r <= 32'd0;
            end else if (i <= 5'd16) begin
                // Accumulate partial product if LSB of areg is set
                if (areg[0])
                    yout_r <= yout_r + breg;
                // Shift multiplicand right and multiplier left
                areg <= areg >> 1;
                breg <= breg << 1;
            end else begin
                // Hold registers at i == 17 (end of operation)
                areg   <= areg;
                breg   <= breg;
                yout_r <= yout_r;
            end
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule