module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    reg [3:0] sec_ones, sec_tens;
    reg [3:0] min_ones, min_tens;
    reg [7:0] hour_bcd;  // Stored in BCD format (01-12)
    reg pm_reg;
    
    // Registered enable signals
    reg sec_inc_reg, min_inc_reg, hour_inc_reg;
    
    always @(posedge clk) begin
        sec_inc_reg <= ena;
        min_inc_reg <= ena && (sec_ones == 4'd9) && (sec_tens == 4'd5);
        hour_inc_reg <= min_inc_reg && (min_ones == 4'd9) && (min_tens == 4'd5);
    end

    // Seconds counter (00-59 BCD)
    always @(posedge clk) begin
        if (reset) begin
            sec_ones <= 4'd0;
            sec_tens <= 4'd0;
        end else if (sec_inc_reg) begin
            if (sec_ones == 4'd9) begin
                sec_ones <= 4'd0;
                sec_tens <= (sec_tens == 4'd5) ? 4'd0 : sec_tens + 1;
            end else begin
                sec_ones <= sec_ones + 1;
            end
        end
    end

    // Minutes counter (00-59 BCD)
    always @(posedge clk) begin
        if (reset) begin
            min_ones <= 4'd0;
            min_tens <= 4'd0;
        end else if (min_inc_reg) begin
            if (min_ones == 4'd9) begin
                min_ones <= 4'd0;
                min_tens <= (min_tens == 4'd5) ? 4'd0 : min_tens + 1;
            end else begin
                min_ones <= min_ones + 1;
            end
        end
    end

    // Hours counter (BCD format 01-12)
    always @(posedge clk) begin
        if (reset) begin
            hour_bcd <= 8'h12;  // BCD 12
        end else if (hour_inc_reg) begin
            if (hour_bcd == 8'h12) begin
                hour_bcd <= 8'h01;
            end else if (hour_bcd[3:0] == 4'd9) begin
                hour_bcd <= {hour_bcd[7:4] + 1, 4'd0};
            end else begin
                hour_bcd <= {hour_bcd[7:4], hour_bcd[3:0] + 1};
            end
        end
    end

    // PM indicator (combinational)
    always @(posedge clk) begin
        if (reset) begin
            pm_reg <= 1'b0;
        end else if (hour_inc_reg && hour_bcd == 8'h11) begin
            pm_reg <= ~pm_reg;
        end
    end

    // Output assignments
    assign ss = {sec_tens, sec_ones};
    assign mm = {min_tens, min_ones};
    assign hh = hour_bcd;
    assign pm = pm_reg;

endmodule