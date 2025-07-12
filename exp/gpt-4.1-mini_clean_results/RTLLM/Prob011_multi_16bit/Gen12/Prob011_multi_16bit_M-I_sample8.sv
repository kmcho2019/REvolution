module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output reg      done
);

    reg [4:0]  i;         // shift count (0 to 17)
    reg [15:0] areg;      // multiplicand register
    reg [15:0] breg;      // multiplier register
    reg [31:0] yout_r;    // product register (accumulator)

    // Shift count and control logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 5'd0;
        end else if (!start) begin
            i <= 5'd0;
        end else if (i < 5'd17) begin
            i <= i + 5'd1;
        end
    end

    // Done flag logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done <= 1'b0;
        end else if (i == 5'd16) begin
            done <= 1'b1;
        end else if (i == 5'd17) begin
            done <= 1'b0;
        end
    end

    // Shift and accumulate logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg   <= 16'd0;
            breg   <= 16'd0;
            yout_r <= 32'd0;
            yout   <= 32'd0;
        end else if (start) begin
            if (i == 5'd0) begin
                // Load inputs at cycle 0
                areg   <= ain;
                breg   <= bin;
                yout_r <= 32'd0;
            end else if (i > 5'd0 && i < 5'd17) begin
                // For bits i-1 (0 to 15), if areg[i-1] == 1, accumulate shifted breg
                if (areg[i-1]) begin
                    // Add breg shifted left by i-1 to accumulator
                    yout_r <= yout_r + ({16'd0, breg} << (i - 1));
                end
            end
            // Update output register every cycle with current accumulator
            yout <= yout_r;
        end else begin
            // If start inactive, clear outputs and registers
            areg   <= 16'd0;
            breg   <= 16'd0;
            yout_r <= 32'd0;
            yout   <= 32'd0;
        end
    end

endmodule