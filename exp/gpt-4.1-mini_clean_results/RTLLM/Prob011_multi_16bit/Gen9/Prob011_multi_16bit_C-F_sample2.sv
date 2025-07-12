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
    reg [15:0]   areg;       // multiplicand register
    reg [31:0]  yout_r;      // product register: upper bits accumulate sum, lower bits shift multiplier

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

    // Done flag generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done_r <= 1'b0;
        end else if (i == 5'd16) begin
            done_r <= 1'b1;
        end else if (i == 5'd17) begin
            done_r <= 1'b0;
        end
    end

    // Shift and accumulate logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg   <= 16'd0;
            yout_r <= 32'd0;
        end else if (!start) begin
            areg   <= 16'd0;
            yout_r <= 32'd0;
        end else begin
            if (i == 5'd0) begin
                areg   <= ain;
                yout_r <= {16'd0, bin}; // Load multiplier in lower half, upper half zeroed
            end else if (i <= 5'd16) begin
                // If current LSB of yout_r (multiplier bit) is set, add shifted multiplicand
                if (yout_r[0]) begin
                    yout_r[31:16] <= yout_r[31:16] + areg;
                end
                yout_r <= yout_r >> 1; // Shift right to process next multiplier bit
                areg <= areg; // hold areg stable (no shift needed)
            end
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule