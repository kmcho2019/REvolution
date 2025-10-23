module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output reg        done
);

    reg [4:0] i;            // shift count from 0 to 17
    reg [15:0] areg;        // multiplicand register
    reg [15:0] breg;        // multiplier register
    reg [31:0] yout_r;      // product register
    reg done_r;

    // Shift count and control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 5'd0;
        end else begin
            if (start) begin
                if (i < 5'd17)
                    i <= i + 5'd1;
                else
                    i <= i; // hold at 17 until start de-asserted
            end else begin
                i <= 5'd0;
            end
        end
    end

    // done flag update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done_r <= 1'b0;
        end else begin
            if (i == 5'd16)
                done_r <= 1'b1;
            else if (i == 5'd17)
                done_r <= 1'b0;
            // else retain previous done_r value
        end
    end

    // Shift and accumulate operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'd0;
            breg <= 16'd0;
            yout_r <= 32'd0;
        end else begin
            if (start) begin
                if (i == 5'd0) begin
                    // Load multiplicand and multiplier
                    areg <= ain;
                    breg <= bin;
                    yout_r <= 32'd0;
                end else if ((i > 5'd0) && (i < 5'd17)) begin
                    // Check bit (i-1) of areg
                    if (areg[i-1]) begin
                        yout_r <= yout_r + ( {16'd0, breg} << (i - 1) );
                    end
                    // else no addition, yout_r unchanged
                end
            end else begin
                // When start is inactive, clear registers
                areg <= 16'd0;
                breg <= 16'd0;
                yout_r <= 32'd0;
            end
        end
    end

    // Output assignment
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            yout <= 32'd0;
            done <= 1'b0;
        end else begin
            yout <= yout_r;
            done <= done_r;
        end
    end

endmodule