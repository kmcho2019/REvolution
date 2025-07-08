module multi_16bit (
    input           clk,
    input           rst_n,
    input           start,
    input  [15:0]   ain,
    input  [15:0]   bin,
    output [31:0]   yout,
    output          done
);

    reg [4:0]    i;         // 5 bits to count up to 17
    reg [15:0]   areg;
    reg [15:0]   breg;
    reg [31:0]   yout_r;
    reg          done_r;

    // Shift count register (i)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 5'd0;
        end else begin
            if (start) begin
                if (i < 5'd17)
                    i <= i + 1'b1;
                else
                    i <= i;
            end else begin
                i <= 5'd0;
            end
        end
    end

    // Done flag register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done_r <= 1'b0;
        end else begin
            if (i == 5'd16)
                done_r <= 1'b1;
            else if (i == 5'd17)
                done_r <= 1'b0;
        end
    end

    // Shift and accumulate operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg   <= 16'd0;
            breg   <= 16'd0;
            yout_r <= 32'd0;
        end else begin
            if (start) begin
                if (i == 5'd0) begin
                    // Load inputs at start of multiplication
                    areg   <= ain;
                    breg   <= bin;
                    yout_r <= 32'd0;
                end else if (i > 5'd0 && i < 5'd17) begin
                    // Check bit i-1 of areg, accumulate if set
                    if (areg[i-1]) begin
                        yout_r <= yout_r + ( {16'd0, breg} << (i - 1) );
                    end
                end
            end else begin
                areg   <= 16'd0;
                breg   <= 16'd0;
                yout_r <= 32'd0;
            end
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule