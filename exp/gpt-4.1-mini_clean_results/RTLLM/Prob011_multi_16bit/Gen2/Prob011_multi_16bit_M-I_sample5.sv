module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

reg [4:0]   i;          // shift count 0 to 17
reg         done_r;     // done flag
reg [15:0]  areg;       // multiplicand
reg [31:0]  breg;       // shifted multiplier register (32 bits for shift and accumulate)
reg [31:0]  yout_r;     // product

// Shift count and control logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        i <= 5'd0;
    else if (!start)
        i <= 5'd0;
    else if (i < 5'd17)
        i <= i + 1'b1;
end

// Done flag generation per problem statement
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        done_r <= 1'b0;
    else if (i == 5'd16)
        done_r <= 1'b1;
    else if (i == 5'd17)
        done_r <= 1'b0;
end

// Shift and accumulate operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        areg   <= 16'd0;
        breg   <= 32'd0;
        yout_r <= 32'd0;
    end else if (start) begin
        if (i == 5'd0) begin
            areg   <= ain;
            breg   <= {16'd0, bin};   // Load multiplier into lower 16 bits
            yout_r <= 32'd0;
        end else if (i >= 5'd1 && i <= 5'd16) begin
            // If current bit of multiplicand (bit i-1) is set, add breg to product
            if (areg[i-1])
                yout_r <= yout_r + breg;

            // Right shift multiplier by 1 for next bit accumulation
            breg <= breg >> 1;
        end else begin
            // After cycle 16, no operation
            breg <= breg;
            yout_r <= yout_r;
        end
    end else begin
        // If start is low, hold registers
        areg   <= areg;
        breg   <= breg;
        yout_r <= yout_r;
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule