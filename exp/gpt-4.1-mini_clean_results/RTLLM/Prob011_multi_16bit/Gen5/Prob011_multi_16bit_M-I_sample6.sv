module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]    i;           // shift count (0 to 17)
    reg          done_r;
    reg [15:0]   areg;
    reg [31:0]   breg;
    reg [31:0]   yout_r;

    wire        counting_enable = start && (i < 5'd17);
    wire        active         = start && (i <= 5'd16);

    // Shift count register update with enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            i <= 5'd0;
        else if (counting_enable)
            i <= i + 5'd1;
        else if (!start)
            i <= 5'd0;
        else
            i <= i;  // hold
    end

    // done flag update: set at i==16, cleared when start=0 or reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            done_r <= 1'b0;
        else if (!start)
            done_r <= 1'b0;
        else if (i == 5'd16)
            done_r <= 1'b1;
    end

    // Registers with enables to reduce toggling
    // Load inputs at i=0
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg   <= 16'd0;
            breg   <= 32'd0;
            yout_r <= 32'd0;
        end else if (active) begin
            if (i == 5'd0) begin
                areg   <= ain;
                breg   <= {16'd0, bin}; // zero-extend multiplier to 32 bits
                yout_r <= 32'd0;
            end else if (i >= 5'd1 && i <= 5'd16) begin
                areg   <= areg >> 1;
                breg   <= breg << 1;
                // yout_r update moved to separate always block for timing
            end
        end else if (!start) begin
            areg   <= 16'd0;
            breg   <= 32'd0;
            yout_r <= 32'd0;
        end
    end

    // Accumulate partial product only when the LSB of areg before shifting is 1
    // To avoid combinational feedback, use a registered areg_lsb
    reg areg_lsb;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            areg_lsb <= 1'b0;
        else if (active) begin
            if (i == 5'd0)
                areg_lsb <= ain[0];  // first bit loaded
            else if (i >= 5'd1 && i <= 5'd16)
                areg_lsb <= areg[0]; // current LSB before shifting (areg updated next cycle)
        end else
            areg_lsb <= 1'b0;
    end

    // Use the registered areg_lsb to conditionally add breg to yout_r
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            yout_r <= 32'd0;
        else if (active && i >= 5'd1 && i <= 5'd16) begin
            if (areg_lsb)
                yout_r <= yout_r + breg;
            else
                yout_r <= yout_r;
        end else if (i == 5'd0)
            yout_r <= 32'd0;
        else if (!start)
            yout_r <= 32'd0;
        else
            yout_r <= yout_r;
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule