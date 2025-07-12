module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output reg         done
);

    reg [4:0] i;               // shift count: 0 to 16 active, 17 resets done
    reg [15:0] areg;           // multiplicand register
    reg [15:0] breg;           // multiplier register
    reg [31:0] yout_r;         // accumulator for product

    wire active = (i > 0 && i <= 16);

    // Shift count and control logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i    <= 5'd0;
            done <= 1'b0;
        end else begin
            if (!start)
                i <= 5'd0;
            else if (i < 5'd17)
                i <= i + 5'd1;

            // done flag generation
            if (i == 5'd16)
                done <= 1'b1;
            else if (i == 5'd17)
                done <= 1'b0;
        end
    end

    // Data path: load inputs at i=0, accumulate shifts 1..16
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg   <= 16'd0;
            breg   <= 16'd0;
            yout_r <= 32'd0;
        end else begin
            if (start) begin
                if (i == 5'd0) begin
                    // Load multiplicand and multiplier
                    areg   <= ain;
                    breg   <= bin;
                    yout_r <= 32'd0;
                end else if (active) begin
                    // Check the (i-1)th bit of multiplier (breg)
                    if (breg[i-1])
                        // Accumulate multiplicand shifted left by (i-1)
                        yout_r <= yout_r + ( {16'd0, areg} << (i-1) );
                    else
                        yout_r <= yout_r; // no change
                end
            end else begin
                // Clear when not started
                areg   <= 16'd0;
                breg   <= 16'd0;
                yout_r <= 32'd0;
            end
        end
    end

    // Output assignment
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            yout <= 32'd0;
        else
            yout <= yout_r;
    end

endmodule