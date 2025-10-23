module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

reg [4:0]   i;        // shift count 0 to 17
reg         done_r;
reg [15:0]  areg;
reg [15:0]  breg;
reg [31:0]  yout_r;

// Shift count and done flag update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i      <= 5'd0;
        done_r <= 1'b0;
    end else begin
        if (!start) begin
            i      <= 5'd0;
            done_r <= 1'b0;
        end else if (i < 5'd17) begin
            i <= i + 1'b1;
            done_r <= (i == 5'd15) ? 1'b1 : (i == 5'd16) ? 1'b0 : done_r;
        end
    end
end

// Shift and accumulate
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
            if (areg[i-1]) 
                yout_r <= yout_r + (breg << (i-1));
        end
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule