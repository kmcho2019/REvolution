module multi_16bit (
    input          clk,
    input          rst_n,    // active-low reset
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]  i;        // shift count: 0..16
    reg [15:0] areg;     // multiplier bits
    reg [31:0] breg;     // multiplicand shifted left
    reg [31:0] yout_r;   // product accumulator
    reg        done_r;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i      <= 5'd0;
            areg   <= 16'd0;
            breg   <= 32'd0;
            yout_r <= 32'd0;
            done_r <= 1'b0;
        end else begin
            if (start) begin
                if (i == 0) begin
                    areg   <= bin;
                    breg   <= {16'd0, ain}; // multiplicand in lower bits
                    yout_r <= 32'd0;
                    i      <= 5'd1;
                    done_r <= 1'b0;
                end else if (i <= 16) begin
                    if (areg[0])
                        yout_r <= yout_r + breg;
                    else
                        yout_r <= yout_r;
                    areg <= areg >> 1;
                    breg <= breg << 1;
                    i <= i + 5'd1;
                    if (i == 16)
                        done_r <= 1'b1;
                end else begin
                    // Hold done_r high until start goes low
                    done_r <= done_r;
                end
            end else begin
                i      <= 5'd0;
                areg   <= areg;
                breg   <= breg;
                yout_r <= yout_r;
                done_r <= 1'b0;
            end
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule