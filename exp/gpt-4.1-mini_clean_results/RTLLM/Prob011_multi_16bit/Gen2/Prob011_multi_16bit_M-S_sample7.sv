module multi_16bit (
    input         clk,
    input         rst_n,
    input         start,
    input  [15:0] ain,
    input  [15:0] bin,
    output [31:0] yout,
    output        done
);

    reg [4:0] i;            // counts from 0 to 17
    reg       done_r;
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] yout_r;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i      <= 5'd0;
            done_r <= 1'b0;
            areg   <= 16'd0;
            breg   <= 16'd0;
            yout_r <= 32'd0;
        end else begin
            if (start) begin
                if (i == 5'd0) begin
                    i      <= 5'd1;
                    areg   <= ain;
                    breg   <= bin;
                    yout_r <= 32'd0;
                    done_r <= 1'b0;
                end else if (i < 5'd16) begin
                    // Accumulate if bit (i-1) of areg is set
                    if (areg[i-1])
                        yout_r <= yout_r + ({16'd0, breg} << (i-1));
                    i <= i + 5'd1;
                end else if (i == 5'd16) begin
                    // Done at cycle 16
                    done_r <= 1'b1;
                    i <= i + 5'd1;
                end else begin
                    // Reset counter and done flag at cycle 17
                    i <= 5'd0;
                    done_r <= 1'b0;
                end
            end else begin
                // When start is low, reset all
                i      <= 5'd0;
                done_r <= 1'b0;
                areg   <= 16'd0;
                breg   <= 16'd0;
                yout_r <= 32'd0;
            end
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule