module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]  i;        // Shift count from 0 to 17
    reg [15:0] areg;     // Multiplicand register
    reg [15:0] breg;     // Multiplier register (will shift right)
    reg [31:0] yout_r;   // Accumulator for the product
    reg        done_r;   // Done flag register

    // Shift count register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 5'd0;
        end else begin
            if (!start) begin
                i <= 5'd0;
            end else if (i < 5'd17) begin
                i <= i + 5'd1;
            end
        end
    end

    // Done flag update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done_r <= 1'b0;
        end else if (i == 5'd16) begin
            done_r <= 1'b1;
        end else if (i == 5'd17) begin
            done_r <= 1'b0;
        end
    end

    // Shift and accumulate operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg   <= 16'd0;
            breg   <= 16'd0;
            yout_r <= 32'd0;
        end else if (start) begin
            if (i == 5'd0) begin
                // Load multiplicand and multiplier at start
                areg   <= ain;
                breg   <= bin;
                yout_r <= 32'd0;
            end else if (i <= 5'd16) begin
                // Check LSB of multiplier
                if (breg[0] == 1'b1) begin
                    // Add multiplicand shifted by (i-1) to accumulator
                    yout_r <= yout_r + ( {16'd0, areg} << (i - 1) );
                end else begin
                    yout_r <= yout_r;
                end
                // Shift multiplier right by 1 to prepare next bit
                breg <= breg >> 1;
            end
        end else begin
            // If not start, clear registers
            areg   <= 16'd0;
            breg   <= 16'd0;
            yout_r <= 32'd0;
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule