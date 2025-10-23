module calendar (
    input CLK,
    input RST,
    output [4:0] Hours,  // Changed to 5 bits (0-23)
    output [5:0] Mins,
    output [5:0] Secs
);

// Internal registers with optimal bit widths
reg [5:0] sec_reg;  // 0-59 needs 6 bits
reg [5:0] min_reg;  // 0-59 needs 6 bits
reg [4:0] hour_reg; // 0-23 needs 5 bits

// Registered terminal count signals
reg sec_max;
reg min_max;
reg hour_inc;

// Terminal count computation
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        sec_max <= 1'b0;
        min_max <= 1'b0;
        hour_inc <= 1'b0;
    end else begin
        sec_max <= (sec_reg == 6'd59);
        min_max <= (min_reg == 6'd59);
        hour_inc <= sec_max && min_max;
    end
end

// Seconds counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        sec_reg <= 6'd0;
    end else begin
        sec_reg <= sec_max ? 6'd0 : sec_reg + 6'd1;
    end
end

// Minutes counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        min_reg <= 6'd0;
    end else if (sec_max) begin
        min_reg <= min_max ? 6'd0 : min_reg + 6'd1;
    end
end

// Hours counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        hour_reg <= 5'd0;
    end else if (hour_inc) begin
        hour_reg <= (hour_reg == 5'd23) ? 5'd0 : hour_reg + 5'd1;
    end
end

// Output assignments
assign Secs = sec_reg;
assign Mins = min_reg;
assign Hours = hour_reg;  // Direct 5-bit output

endmodule