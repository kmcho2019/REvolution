module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,   // multiplicand
    input  [15:0]  bin,   // multiplier
    output [31:0]  yout,
    output         done
);

    reg [4:0] i;              // Shift count: 0 to 17 (to cover 0..16 and reset)
    reg [15:0] areg;          // Holds multiplier (bin)
    reg [15:0] breg;          // Holds multiplicand (ain)
    reg [31:0] yout_r;        // Accumulator for product
    reg        done_r;

    // Shift count register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 5'd0;
        end else begin
            if (!start)
                i <= 5'd0;
            else if (i < 5'd17)
                i <= i + 5'd1;
        end
    end

    // Multiplication completion flag update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done_r <= 1'b0;
        end else begin
            if (i == 5'd16)
                done_r <= 1'b1;
            else if (i == 5'd17)
                done_r <= 1'b0;
        end
    end

    // Shift and accumulate operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'd0;
            breg <= 16'd0;
            yout_r <= 32'd0;
        end else if (start) begin
            if (i == 5'd0) begin
                // Load multiplicand and multiplier at start
                areg <= bin;
                breg <= ain;
                yout_r <= 32'd0;
            end else if (i > 5'd0 && i < 5'd17) begin
                // Check the (i-1)th bit of multiplier (areg)
                if (areg[i - 1]) begin
                    // Add multiplicand shifted left by i-1 to product accumulator
                    yout_r <= yout_r + ( {16'd0, breg} << (i - 1) );
                end
            end
        end else begin
            // If not started, clear registers
            areg <= 16'd0;
            breg <= 16'd0;
            yout_r <= 32'd0;
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule