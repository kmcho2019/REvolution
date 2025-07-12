module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0] i;               // Shift count (0 to 17)
    reg done_r;
    reg [15:0] a_reg;          // Registered multiplicand
    reg [15:0] b_reg;          // Registered multiplier
    reg [31:0] yout_r;         // Accumulator for product

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

    // Shift and accumulate multiplication
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg  <= 16'd0;
            b_reg  <= 16'd0;
            yout_r <= 32'd0;
        end else if (start) begin
            if (i == 5'd0) begin
                // Load inputs at start
                a_reg  <= ain;
                b_reg  <= bin;
                yout_r <= 32'd0;
            end else if (i <= 5'd16) begin
                // For each bit of b_reg, if bit (i-1) is 1, add (a_reg shifted left by i-1) to yout_r
                if (b_reg[i-1])
                    yout_r <= yout_r + ( {16'd0, a_reg} << (i-1) );
                else
                    yout_r <= yout_r; // Hold value when bit is zero
            end else begin
                yout_r <= yout_r; // Hold after completion
            end
        end else begin
            // Reset outputs when not starting
            a_reg  <= 16'd0;
            b_reg  <= 16'd0;
            yout_r <= 32'd0;
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule