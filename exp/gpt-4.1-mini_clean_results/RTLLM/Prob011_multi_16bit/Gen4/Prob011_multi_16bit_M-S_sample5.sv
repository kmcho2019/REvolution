module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]    i;          // shift count: 0 to 17
    reg          done_r;
    reg [15:0]   areg;
    reg [31:0]   breg;
    reg [31:0]   yout_r;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i      <= 5'd0;
            done_r <= 1'b0;
            areg   <= 16'd0;
            breg   <= 32'd0;
            yout_r <= 32'd0;
        end else if (start) begin
            if (i == 5'd0) begin
                areg   <= ain;
                breg   <= {16'd0, bin}; // zero-extend multiplier
                yout_r <= 32'd0;
                done_r <= 1'b0;
                i      <= i + 5'd1;
            end else if (i < 5'd17) begin
                if (areg[0])
                    yout_r <= yout_r + breg;
                else
                    yout_r <= yout_r;
                areg <= areg >> 1;
                breg <= breg << 1;
                i <= i + 5'd1;
                done_r <= (i == 5'd16);
            end else begin
                i <= 5'd0;
                done_r <= 1'b0;
            end
        end else begin
            i      <= 5'd0;
            done_r <= 1'b0;
            areg   <= 16'd0;
            breg   <= 32'd0;
            yout_r <= 32'd0;
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule