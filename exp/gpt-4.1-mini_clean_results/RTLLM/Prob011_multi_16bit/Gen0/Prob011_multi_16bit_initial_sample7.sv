module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

// Internal registers
reg [4:0]   i;        // shift count (0 to 17)
reg         done_r;   // done flag
reg [15:0]  areg;     // multiplicand register
reg [15:0]  breg;     // multiplier register
reg [31:0]  yout_r;   // product register

// Shift count update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i <= 5'd0;
    end else if (!start) begin
        i <= 5'd0;
    end else if (i < 5'd17) begin
        i <= i + 1'b1;
    end
end

// done flag generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        done_r <= 1'b0;
    end else if (i == 5'd16) begin
        done_r <= 1'b1;
    end else if (i == 5'd17) begin
        done_r <= 1'b0;
    end
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
        end else if (i > 5'd0 && i < 5'd17) begin
            // Check bit (i-1) of areg; if set, add breg shifted by (i-1) to yout_r
            if (areg[i-1]) begin
                yout_r <= yout_r + ( {16'd0, breg} << (i-1) );
            end
        end
    end else begin
        // When start is not asserted, keep registers stable except i reset handled above
        // (No else action needed)
    end
end

// Output assignments
assign yout = yout_r;
assign done = done_r;

endmodule