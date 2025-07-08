module multi_16bit (
    input            clk,
    input            rst_n,
    input            start,
    input  [15:0]    ain,
    input  [15:0]    bin,
    output [31:0]    yout,
    output           done
);

    reg [4:0]  i;           // shift count, 5 bits to cover 0..17
    reg        done_r;
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] yout_r;

    // Shift count register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 5'd0;
        end else begin
            if (!start) begin
                i <= 5'd0;
            end else if (i < 5'd17) begin
                i <= i + 1'b1;
            end
        end
    end

    // done flag generation
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

    // shift and accumulate operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'd0;
            breg <= 16'd0;
            yout_r <= 32'd0;
        end else begin
            if (start) begin
                if (i == 5'd0) begin
                    areg <= ain;
                    breg <= bin;
                    yout_r <= 32'd0;
                end else if (i > 5'd0 && i <= 5'd16) begin
                    // check bit (i-1) of areg
                    if (areg[i-1]) begin
                        // accumulate breg shifted left by i-1
                        yout_r <= yout_r + ({16'd0, breg} << (i - 1));
                    end
                end
                // For i==17 do nothing (wait state before resetting done)
            end else begin
                // When start is low, registers keep their state or can reset yout_r?
                // According to description, i resets to 0 when start==0, so registers reset will happen on reset only.
            end
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule