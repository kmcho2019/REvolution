module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]     i;         // shift count (0 to 17)
    reg           done_r;
    reg [31:0]    areg;      // shifted multiplicand
    reg [15:0]    breg;      // shifting multiplier
    reg [31:0]    yout_r;    // accumulator

    wire          active;    // indicates multiplication operation in progress

    assign active = start && (i <= 5'd16);

    // Shift count control with enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            i <= 5'd0;
        else if (!start)
            i <= 5'd0;
        else if (i < 5'd17)
            i <= i + 5'd1;
    end

    // Done flag control with gated update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            done_r <= 1'b0;
        else if (i == 5'd16)
            done_r <= 1'b1;
        else if (i == 5'd17)
            done_r <= 1'b0;
    end

    // Shift and accumulate logic with clock enable gating
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg   <= 32'd0;
            breg   <= 16'd0;
            yout_r <= 32'd0;
        end else if (!start) begin
            areg   <= 32'd0;
            breg   <= 16'd0;
            yout_r <= 32'd0;
        end else if (active) begin
            if (i == 5'd0) begin
                areg   <= {16'd0, ain};  // Load multiplicand at LSB
                breg   <= bin;           // Load multiplier
                yout_r <= 32'd0;
            end else if (i <= 5'd16) begin
                if (areg[i-1])           // Check bit (i-1) of areg (multiplicand)
                    yout_r <= yout_r + (breg << (i-1));
            end
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule