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
    reg [31:0]   breg_ext;   // extended multiplier shifted progressively
    reg [31:0]   yout_r;

    // Control signals for clock enables
    wire cnt_enable        = start && (i < 5'd17);
    wire load_inputs       = start && (i == 5'd0);
    wire shift_acc_enable  = start && (i > 5'd0) && (i < 5'd17);
    wire accumulate_enable = shift_acc_enable && areg[0];

    // Shift count register with clock enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 5'd0;
        end else if (!start) begin
            i <= 5'd0;
        end else if (cnt_enable) begin
            i <= i + 5'd1;
        end
    end

    // Done flag update: set at i == 16, reset on reset or start deassert
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done_r <= 1'b0;
        end else if (!start) begin
            done_r <= 1'b0;
        end else if (i == 5'd16) begin
            done_r <= 1'b1;
        end
    end

    // Shift and accumulate operation with clock enables to reduce toggling
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg    <= 16'd0;
            breg_ext <= 32'd0;
            yout_r  <= 32'd0;
        end else if (!start) begin
            areg    <= 16'd0;
            breg_ext <= 32'd0;
            yout_r  <= 32'd0;
        end else begin
            if (load_inputs) begin
                // Load multiplicand and multiplier into registers, clear accumulator
                areg    <= ain;
                breg_ext <= {16'd0, bin};
                yout_r  <= 32'd0;
            end else if (shift_acc_enable) begin
                // Accumulate if LSB of areg is set
                if (accumulate_enable)
                    yout_r <= yout_r + breg_ext;
                // Shift registers for next bit
                areg    <= areg >> 1;
                breg_ext <= breg_ext << 1;
            end
            // Otherwise hold values (no change)
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule