module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Packed BCD registers
    reg [7:0] ss_reg;  // {tens[3:0], ones[3:0]}
    reg [7:0] mm_reg;
    reg [3:0] hour;    // 1-12 counter
    
    // Registered rollover signals
    reg sec_rollover, min_rollover;
    
    // Combinational PM indicator
    assign pm = (hour < 4'd12) ? 1'b0 : 1'b1;
    
    // Seconds counter (00-59)
    always @(posedge clk) begin
        if (reset) begin
            ss_reg <= 8'h00;
            sec_rollover <= 1'b0;
        end else if (ena) begin
            if (ss_reg[3:0] == 4'd9) begin
                ss_reg[3:0] <= 4'd0;
                if (ss_reg[7:4] == 4'd5) begin
                    ss_reg[7:4] <= 4'd0;
                    sec_rollover <= 1'b1;
                end else begin
                    ss_reg[7:4] <= ss_reg[7:4] + 1;
                    sec_rollover <= 1'b0;
                end
            end else begin
                ss_reg[3:0] <= ss_reg[3:0] + 1;
                sec_rollover <= 1'b0;
            end
        end else begin
            sec_rollover <= 1'b0;
        end
    end

    // Minutes counter (00-59)
    always @(posedge clk) begin
        if (reset) begin
            mm_reg <= 8'h00;
            min_rollover <= 1'b0;
        end else if (ena && sec_rollover) begin
            if (mm_reg[3:0] == 4'd9) begin
                mm_reg[3:0] <= 4'd0;
                if (mm_reg[7:4] == 4'd5) begin
                    mm_reg[7:4] <= 4'd0;
                    min_rollover <= 1'b1;
                end else begin
                    mm_reg[7:4] <= mm_reg[7:4] + 1;
                    min_rollover <= 1'b0;
                end
            end else begin
                mm_reg[3:0] <= mm_reg[3:0] + 1;
                min_rollover <= 1'b0;
            end
        end else begin
            min_rollover <= 1'b0;
        end
    end

    // Hours counter (1-12)
    always @(posedge clk) begin
        if (reset) begin
            hour <= 4'd12;
        end else if (ena && sec_rollover && min_rollover) begin
            if (hour == 4'd12) begin
                hour <= 4'd1;
            end else begin
                hour <= hour + 1;
            end
        end
    end

    // BCD outputs
    wire [3:0] hr_tens = (hour > 4'd9) ? 4'd1 : 4'd0;
    wire [3:0] hr_ones = (hour > 4'd9) ? hour - 4'd10 : hour;

    assign ss = ss_reg;
    assign mm = mm_reg;
    assign hh = {hr_tens, hr_ones};

endmodule