module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Registered rollover signals to break critical path
reg sec_roll_reg;
reg min_roll_reg;

// Next value calculations
wire [5:0] next_sec = (Secs == 6'd59) ? 6'd0 : (Secs + 6'd1);
wire [5:0] next_min = (Mins == 6'd59) ? 6'd0 : (Mins + 6'd1);
wire [4:0] next_hour = (Hours == 5'd23) ? 5'd0 : (Hours + 5'd1);

// Sequential update blocks (split for better timing)
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        sec_roll_reg <= 1'b0;
    end else begin
        Secs <= next_sec;
        sec_roll_reg <= (Secs == 6'd59);
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
        min_roll_reg <= 1'b0;
    end else if (sec_roll_reg) begin
        Mins <= next_min;
        min_roll_reg <= (Mins == 6'd59);
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 5'd0;
    end else if (sec_roll_reg && min_roll_reg) begin
        Hours <= next_hour;
    end
end

endmodule