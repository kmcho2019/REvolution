module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

// Internal registers and signals
reg [4:0]   i;        // shift count (0 to 17)
reg         done_r;   // done flag
reg [15:0]  areg;     // multiplicand register
reg [15:0]  breg;     // multiplier register
reg [31:0]  yout_r;   // product register

// Local wire for shifted value of breg
wire [31:0] shifted_breg;
assign shifted_breg = (i > 0 && i < 17) ? ({16'd0, breg} << (i - 1)) : 32'd0;

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

// Shift and accumulate operation with enable controls
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
            // Only update yout_r if corresponding bit of areg is set to minimize toggling and computation
            if (areg[i-1]) begin
                yout_r <= yout_r + shifted_breg;
            end
        end
        // If bit is zero, hold yout_r without change to avoid unnecessary toggling
    end
    // else keep registers stable when start is not asserted (no else needed)
end

// Output assignments
assign yout = yout_r;
assign done = done_r;

endmodule