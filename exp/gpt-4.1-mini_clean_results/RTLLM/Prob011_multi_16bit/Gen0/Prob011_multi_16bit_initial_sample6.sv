module multi_16bit (
    input        clk,
    input        rst_n,
    input        start,
    input  [15:0] ain,
    input  [15:0] bin,
    output [31:0] yout,
    output       done
);

    reg [4:0] i;             // shift count register: 0 to 17 max (5 bits sufficient)
    reg       done_r;
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] yout_r;

    // Shift count register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 5'd0;
        end else begin
            if (start) begin
                if (i < 5'd17)
                    i <= i + 5'd1;
            end else begin
                i <= 5'd0;
            end
        end
    end

    // Done flag update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done_r <= 1'b0;
        end else begin
            if (i == 5'd16) begin
                done_r <= 1'b1;
            end else if (i == 5'd17) begin
                done_r <= 1'b0;
            end
        end
    end

    // Shift and accumulate operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg  <= 16'd0;
            breg  <= 16'd0;
            yout_r <= 32'd0;
        end else begin
            if (start) begin
                if (i == 5'd0) begin
                    areg  <= ain;
                    breg  <= bin;
                    yout_r <= 32'd0;
                end else if (i > 5'd0 && i < 5'd17) begin
                    // Check bit i-1 of areg (multiplicand)
                    if (areg[i-1]) begin
                        // Add shifted breg (multiplier) to yout_r
                        yout_r <= yout_r + ( {16'd0, breg} << (i-1) );
                    end
                    // else do nothing (add zero)
                end
            end else begin
                // If start not asserted, clear product register
                yout_r <= 32'd0;
                areg <= 16'd0;
                breg <= 16'd0;
            end
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule