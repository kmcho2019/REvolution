module calendar (
    input CLK,
    input RST,
    output [5:0] Hours,
    output [5:0] Mins,
    output [5:0] Secs
);

reg [5:0] secs_reg;
reg [5:0] mins_reg;
reg [4:0] hours_reg;  // 5 bits sufficient for 0-23

wire sec_rollover = (secs_reg == 6'd59);
wire min_rollover = (mins_reg == 6'd59) & sec_rollover;

// Seconds counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        secs_reg <= 6'd0;
    end else begin
        secs_reg <= sec_rollover ? 6'd0 : secs_reg + 6'd1;
    end
end

// Minutes counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        mins_reg <= 6'd0;
    end else if (sec_rollover) begin
        mins_reg <= min_rollover ? 6'd0 : mins_reg + 6'd1;
    end
end

// Hours counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        hours_reg <= 5'd0;
    end else if (min_rollover & sec_rollover) begin
        hours_reg <= (hours_reg == 5'd23) ? 5'd0 : hours_reg + 5'd1;
    end
end

// Output assignments with zero-extension for hours
assign Secs = secs_reg;
assign Mins = mins_reg;
assign Hours = {1'b0, hours_reg};

endmodule