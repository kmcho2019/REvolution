module calendar (
    input CLK,
    input RST,
    output [5:0] Hours,
    output [5:0] Mins,
    output [5:0] Secs
);

// Internal registers with optimal bit widths
reg [5:0] sec_reg;  // 0-59 needs 6 bits
reg [5:0] min_reg;  // 0-59 needs 6 bits
reg [4:0] hour_reg; // 0-23 needs 5 bits

// Terminal count signals
wire sec_max = (sec_reg == 6'd59);
wire min_max = (min_reg == 6'd59);

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
    end else if (sec_max && min_max) begin
        hour_reg <= (hour_reg == 5'd23) ? 5'd0 : hour_reg + 5'd1;
    end
end

// Output assignments
assign Secs = sec_reg;
assign Mins = min_reg;
assign Hours = {1'b0, hour_reg}; // Zero-extend to 6 bits

endmodule