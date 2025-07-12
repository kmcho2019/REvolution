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
    reg [7:0] ss_reg;  // ss_reg[7:4] = tens, ss_reg[3:0] = ones
    reg [7:0] mm_reg;
    reg [3:0] hour;    // 1-12 counter
    
    // Registered rollover signals
    reg sec_rollover_reg;
    reg min_rollover_reg;
    
    // Registered enable signals
    reg min_ena;
    reg hour_ena;
    
    // PM indicator
    reg pm_reg;
    assign pm = pm_reg;
    
    // Registered BCD outputs
    reg [7:0] hh_reg;
    assign hh = hh_reg;
    assign mm = mm_reg;
    assign ss = ss_reg;

    // Seconds counter (00-59)
    always @(posedge clk) begin
        if (reset) begin
            ss_reg <= 8'h00;
            sec_rollover_reg <= 1'b0;
        end
        else if (ena) begin
            if (ss_reg[3:0] == 4'd9) begin
                ss_reg[3:0] <= 4'd0;
                if (ss_reg[7:4] == 4'd5) begin
                    ss_reg[7:4] <= 4'd0;
                    sec_rollover_reg <= 1'b1;
                end
                else begin
                    ss_reg[7:4] <= ss_reg[7:4] + 1;
                    sec_rollover_reg <= 1'b0;
                end
            end
            else begin
                ss_reg[3:0] <= ss_reg[3:0] + 1;
                sec_rollover_reg <= 1'b0;
            end
        end
        else begin
            sec_rollover_reg <= 1'b0;
        end
    end

    // Minutes counter (00-59)
    always @(posedge clk) begin
        if (reset) begin
            mm_reg <= 8'h00;
            min_rollover_reg <= 1'b0;
            min_ena <= 1'b0;
        end
        else begin
            min_ena <= ena & sec_rollover_reg;
            
            if (min_ena) begin
                if (mm_reg[3:0] == 4'd9) begin
                    mm_reg[3:0] <= 4'd0;
                    if (mm_reg[7:4] == 4'd5) begin
                        mm_reg[7:4] <= 4'd0;
                        min_rollover_reg <= 1'b1;
                    end
                    else begin
                        mm_reg[7:4] <= mm_reg[7:4] + 1;
                        min_rollover_reg <= 1'b0;
                    end
                end
                else begin
                    mm_reg[3:0] <= mm_reg[3:0] + 1;
                    min_rollover_reg <= 1'b0;
                end
            end
            else begin
                min_rollover_reg <= 1'b0;
            end
        end
    end

    // Hours counter (1-12) and PM indicator
    always @(posedge clk) begin
        if (reset) begin
            hour <= 4'd12;
            pm_reg <= 1'b0;
            hour_ena <= 1'b0;
        end
        else begin
            hour_ena <= min_ena & min_rollover_reg;
            
            if (hour_ena) begin
                if (hour == 4'd12)
                    hour <= 4'd1;
                else
                    hour <= hour + 1;
                
                // Toggle PM at 12->1 transition
                if (hour == 4'd11)
                    pm_reg <= ~pm_reg;
            end
        end
    end

    // BCD hour output conversion (registered)
    always @(posedge clk) begin
        if (reset) begin
            hh_reg <= 8'h12;
        end
        else begin
            hh_reg <= (hour > 4'd9) ? {4'd1, hour - 4'd10} : {4'd0, hour};
        end
    end

endmodule