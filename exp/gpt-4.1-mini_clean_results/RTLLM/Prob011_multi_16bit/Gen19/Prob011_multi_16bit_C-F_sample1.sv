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
    reg [15:0]   areg;       // shifted multiplicand bits (acts as bit selector)
    reg [31:0]   breg_ext;   // extended multiplier shifted left progressively
    reg [31:0]   yout_r;     // accumulator for product

    // Control enables
    wire cnt_enable       = start && (i < 5'd17);
    wire load_inputs      = start && (i == 5'd0);
    wire shift_acc_enable = start && (i > 5'd0) && (i < 5'd17);
    wire accumulate_enable= shift_acc_enable && areg[0];

    // Shift count register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            i <= 5'd0;
        else if (!start)
            i <= 5'd0;
        else if (cnt_enable)
            i <= i + 5'd1;
    end

    // Done flag update: set at i==16, cleared on reset or start deassertion
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            done_r <= 1'b0;
        else if (!start)
            done_r <= 1'b0;
        else if (i == 5'd16)
            done_r <= 1'b1;
    end

    // Shift and accumulate operation with clock enable gating
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg     <= 16'd0;
            breg_ext <= 32'd0;
            yout_r   <= 32'd0;
        end else if (!start) begin
            areg     <= 16'd0;
            breg_ext <= 32'd0;
            yout_r   <= 32'd0;
        end else begin
            if (load_inputs) begin
                // Load inputs and clear accumulator
                areg     <= ain;
                breg_ext <= {16'd0, bin};
                yout_r   <= 32'd0;
            end else if (shift_acc_enable) begin
                // Accumulate partial product if current bit is 1
                if (accumulate_enable)
                    yout_r <= yout_r + breg_ext;
                // Shift areg right, breg_ext left for next bit
                areg     <= areg >> 1;
                breg_ext <= breg_ext << 1;
            end
            // At other times, keep registers unchanged (no else branch needed)
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule