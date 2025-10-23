module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output reg        done
);

    reg [4:0] i;                // shift count: 0 to 16
    reg [15:0] areg;            // multiplicand register
    reg [15:0] breg;            // multiplier register
    reg [31:0] yout_r;          // product accumulator

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i      <= 5'd0;
            areg   <= 16'd0;
            breg   <= 16'd0;
            yout_r <= 32'd0;
            done   <= 1'b0;
        end else begin
            if (start) begin
                if (i == 5'd0) begin
                    // Load inputs on first cycle after start
                    areg   <= ain;
                    breg   <= bin;
                    yout_r <= 32'd0;
                    i      <= 5'd1;
                    done   <= 1'b0;
                end else if (i <= 5'd16) begin
                    // On each cycle, if LSB of multiplier is set, accumulate shifted multiplicand
                    if (breg[0])
                        yout_r <= yout_r + ( {16'd0, areg} << (i - 1) );
                    else
                        yout_r <= yout_r;
                    breg <= breg >> 1;
                    i <= i + 1;
                    done <= (i == 5'd16) ? 1'b1 : 1'b0;
                end else begin
                    // After finishing, wait for start deassertion to reset i
                    if (!start) begin
                        i <= 5'd0;
                        done <= 1'b0;
                    end
                end
            end else begin
                // If start not asserted, reset all registers
                i      <= 5'd0;
                areg   <= 16'd0;
                breg   <= 16'd0;
                yout_r <= 32'd0;
                done   <= 1'b0;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            yout <= 32'd0;
        else
            yout <= yout_r;
    end

endmodule