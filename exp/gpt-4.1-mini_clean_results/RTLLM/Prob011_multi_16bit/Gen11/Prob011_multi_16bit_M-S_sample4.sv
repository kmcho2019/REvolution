module multi_16bit (
    input          clk,
    input          rst_n,    // asynchronous active-low reset
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]   i;        // shift count: 0..17
    reg         done_r;
    reg [15:0]  areg;
    reg [31:0]  breg;
    reg [31:0]  yout_r;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i      <= 5'd0;
            done_r <= 1'b0;
            areg   <= 16'd0;
            breg   <= 32'd0;
            yout_r <= 32'd0;
        end else begin
            if (start) begin
                if (i == 5'd0) begin
                    // Load operands at start
                    areg   <= ain;
                    breg   <= {16'd0, bin};  // zero-extend bin to 32 bits
                    yout_r <= 32'd0;
                    i      <= 5'd1;
                    done_r <= 1'b0;
                end else if (i <= 5'd16) begin
                    // Accumulate if LSB of areg is 1
                    if (areg[0])
                        yout_r <= yout_r + breg;
                    // Shift areg right, breg left
                    areg <= areg >> 1;
                    breg <= breg << 1;
                    i <= i + 5'd1;

                    // Set done flag at i == 16 after accumulation
                    done_r <= (i == 5'd16) ? 1'b1 : 1'b0;
                end else begin
                    // After i == 17, hold done flag low and registers hold value
                    i <= 5'd0;
                    done_r <= 1'b0;
                end
            end else begin
                // When not started, reset all registers
                i      <= 5'd0;
                done_r <= 1'b0;
                areg   <= 16'd0;
                breg   <= 32'd0;
                yout_r <= 32'd0;
            end
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule