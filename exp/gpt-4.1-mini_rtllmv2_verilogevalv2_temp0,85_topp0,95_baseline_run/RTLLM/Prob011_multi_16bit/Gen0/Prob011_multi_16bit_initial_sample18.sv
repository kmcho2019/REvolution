module multi_16bit (
    input        clk,
    input        rst_n,
    input        start,
    input  [15:0] ain,
    input  [15:0] bin,
    output reg [31:0] yout,
    output reg       done
);

    reg [4:0] i;                // Shift count (0 to 17)
    reg [15:0] areg;            // Multiplicand register
    reg [15:0] breg;            // Multiplier register
    reg [31:0] yout_r;          // Accumulated product register
    reg        done_r;          // Done flag register

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

    // Done flag generation
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
                    areg   <= ain;
                    breg   <= bin;
                    yout_r <= 32'd0;
                end else if (i > 5'd0 && i < 5'd17) begin
                    if (areg[i-1]) begin
                        yout_r <= yout_r + ( {16'd0, breg} << (i-1) );
                    end
                end
            end else begin
                // If start is not active, keep registers unchanged or reset them?
                // Per spec, only reset on rst_n, so do nothing here.
            end
        end
    end

    // Output assignments
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