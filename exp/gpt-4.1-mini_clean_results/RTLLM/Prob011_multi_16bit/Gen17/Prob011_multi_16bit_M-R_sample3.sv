module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0] i;               // shift count, 0 to 17 (to track completion)
    reg [15:0] areg;           // multiplicand register
    reg [15:0] breg;           // multiplier register
    reg [31:0] yout_r;         // product accumulator register
    reg done_r;

    // Counter and control logic
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
            areg <= 16'd0;
            breg <= 16'd0;
            yout_r <= 32'd0;
        end else if (start) begin
            if (i == 5'd0) begin
                // Load multiplicand and multiplier at start
                areg <= ain;
                breg <= bin;
                yout_r <= 32'd0;
            end else if (i >= 5'd1 && i <= 5'd16) begin
                // Check bit (i-1) of multiplicand; if 1 add shifted multiplier
                if (areg[i - 1]) begin
                    yout_r <= yout_r + ( {16'd0, breg} << (i - 1) );
                end
            end
        end else begin
            // If start not asserted, reset outputs and registers
            areg <= areg;
            breg <= breg;
            yout_r <= yout_r;
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule