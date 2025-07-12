module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,  // Reduced to 5 bits (0-23)
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Gray code for seconds to reduce switching power
reg [5:0] secs_gray;
wire sec_rollover = (Secs == 6'd59);
wire min_rollover = (Mins == 6'd59) & sec_rollover;

// Shared rollover flags
reg sec_rollover_reg;
reg min_rollover_reg;

// Generate rollover flags
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        sec_rollover_reg <= 1'b0;
        min_rollover_reg <= 1'b0;
    end else begin
        sec_rollover_reg <= sec_rollover;
        min_rollover_reg <= min_rollover;
    end
end

// Seconds counter with Gray encoding
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        secs_gray <= 6'd0;
    end else begin
        if (sec_rollover) begin
            Secs <= 6'd0;
            secs_gray <= 6'd0;
        end else begin
            Secs <= Secs + 6'd1;
            // Convert binary to Gray code
            secs_gray <= (Secs + 6'd1) ^ ((Secs + 6'd1) >> 1);
        end
    end
end

// Minutes counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
    end else if (sec_rollover_reg) begin
        if (min_rollover_reg) begin
            Mins <= 6'd0;
        end else begin
            Mins <= Mins + 6'd1;
        end
    end
end

// Hours counter with clock gating
wire hours_update = min_rollover_reg & sec_rollover_reg;
reg hours_clk_en;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        hours_clk_en <= 1'b0;
    end else begin
        hours_clk_en <= hours_update;
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 5'd0;
    end else if (hours_clk_en) begin
        if (Hours == 5'd23) begin
            Hours <= 5'd0;
        end else begin
            Hours <= Hours + 5'd1;
        end
    end
end

endmodule