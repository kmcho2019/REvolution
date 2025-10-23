module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]   i;          // shift count: 0 to 16 (plus 17 for done reset)
    reg [15:0]  areg;       // multiplicand register
    reg [15:0]  breg;       // multiplier register
    reg [31:0]  yout_r;     // product register
    reg         done_r;     // done flag

    // Shift count and done flag update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i      <= 5'd0;
            done_r <= 1'b0;
        end else begin
            if (start) begin
                if (i < 5'd17)
                    i <= i + 5'd1;
            end else begin
                i <= 5'd0;
            end

            if (!rst_n)
                done_r <= 1'b0;
            else if (i == 5'd16)
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
                end else if (i >= 5'd1 && i <= 5'd16) begin
                    if (areg[i-1])
                        yout_r <= yout_r + ( {16'd0, breg} << (i-1) );
                    else
                        yout_r <= yout_r;
                end
            end else begin
                // When start is low, reset registers
                areg   <= 16'd0;
                breg   <= 16'd0;
                yout_r <= 32'd0;
            end
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule