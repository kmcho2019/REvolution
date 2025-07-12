module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

reg [4:0]   i;        // shift count
reg         done_r;   // done flag
reg [15:0]  areg;     // multiplicand
reg [15:0]  breg;     // multiplier
reg [31:0]  yout_r;   // product

// Shift count and control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        i <= 5'd0;
    else if (!start)
        i <= 5'd0;
    else if (i < 5'd16)
        i <= i + 1'b1;
end

// Done flag asserts at count 16
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        done_r <= 1'b0;
    else if (i == 5'd16)
        done_r <= 1'b1;
    else if (!start)
        done_r <= 1'b0;
end

// Shift and accumulate operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        areg   <= 16'd0;
        breg   <= 16'd0;
        yout_r <= 32'd0;
    end else if (start) begin
        if (i == 5'd0) begin
            areg   <= ain;
            breg   <= bin;
            yout_r <= 32'd0;
        end else if (i <= 5'd16) begin
            if (areg[i-1])
                yout_r <= yout_r + ({16'd0, breg} << (i-1));
        end
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule