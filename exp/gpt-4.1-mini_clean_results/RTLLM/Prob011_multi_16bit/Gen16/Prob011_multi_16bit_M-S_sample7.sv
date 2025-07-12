module multi_16bit (
    input          clk,
    input          rst_n,    // active low reset
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]   i;          // counts 0 to 16
    reg         done_r;
    reg [15:0]  areg;
    reg [31:0] breg;
    reg [31:0] yout_r;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i      <= 5'd0;
            done_r <= 1'b0;
            areg   <= 16'd0;
            breg   <= 32'd0;
            yout_r <= 32'd0;
        end else if (!start) begin
            // Reset operation on start deassert
            i      <= 5'd0;
            done_r <= 1'b0;
            // Keep data registers stable (no reset)
        end else begin
            // start asserted
            if (i == 5'd0) begin
                // Load inputs at start
                areg   <= ain;
                breg   <= {16'd0, bin};
                yout_r <= 32'd0;
                done_r <= 1'b0;
                i      <= i + 5'd1;
            end else if (i <= 5'd16) begin
                // Multiply cycles
                if (areg[0])
                    yout_r <= yout_r + breg;
                else
                    yout_r <= yout_r;

                areg <= areg >> 1;
                breg <= breg << 1;

                i <= i + 5'd1;

                if (i == 5'd16)
                    done_r <= 1'b1;
            end else begin
                // Hold done flag and registers after completion
                done_r <= done_r;
                areg   <= areg;
                breg   <= breg;
                yout_r <= yout_r;
                i      <= i;
            end
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule