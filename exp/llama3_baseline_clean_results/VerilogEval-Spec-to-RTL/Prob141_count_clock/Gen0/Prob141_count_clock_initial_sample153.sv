module bcd_counter(clk, reset, ena, load, load_value, count);
    input clk, reset, ena, load;
    input [3:0] load_value;
    output [3:0] count;
    reg [3:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 0;
        end else if (load) begin
            count <= load_value;
        end else if (ena) begin
            if (count == 9) begin
                count <= 0;
            end else begin
                count <= count + 1;
            end
        end
    end

endmodule

module seconds_counter(clk, reset, ena, ss);
    input clk, reset, ena;
    output [7:0] ss;
    reg [7:0] ss;

    bcd_counter bcd1(clk, reset, ena, 1'b0, 4'd0, ss[3:0]);
    bcd_counter bcd2(clk, reset, ena, 1'b0, 4'd0, ss[7:4]);

    always @(posedge clk) begin
        if (reset) begin
            ss <= 0;
        end else if (ena) begin
            if (ss == 59) begin
                ss <= 0;
            end else begin
                if (ss[3:0] == 9) begin
                    if (ss[7:4] == 5) begin
                        ss <= 0;
                    end else begin
                        ss[7:4] <= ss[7:4] + 1;
                        ss[3:0] <= 0;
                    end
                end else begin
                    ss[3:0] <= ss[3:0] + 1;
                end
            end
        end
    end

endmodule

module minutes_counter(clk, reset, ena, mm);
    input clk, reset, ena;
    output [7:0] mm;
    reg [7:0] mm;

    bcd_counter bcd1(clk, reset, ena, 1'b0, 4'd0, mm[3:0]);
    bcd_counter bcd2(clk, reset, ena, 1'b0, 4'd0, mm[7:4]);

    always @(posedge clk) begin
        if (reset) begin
            mm <= 0;
        end else if (ena) begin
            if (mm == 59) begin
                mm <= 0;
            end else begin
                if (mm[3:0] == 9) begin
                    if (mm[7:4] == 5) begin
                        mm <= 0;
                    end else begin
                        mm[7:4] <= mm[7:4] + 1;
                        mm[3:0] <= 0;
                    end
                end else begin
                    mm[3:0] <= mm[3:0] + 1;
                end
            end
        end
    end

endmodule

module hours_counter(clk, reset, ena, pm, hh);
    input clk, reset, ena;
    output pm;
    output [7:0] hh;
    reg pm;
    reg [7:0] hh;

    bcd_counter bcd1(clk, reset, ena, 1'b0, 4'd0, hh[3:0]);
    bcd_counter bcd2(clk, reset, ena, 1'b0, 4'd1, hh[7:4]);

    always @(posedge clk) begin
        if (reset) begin
            hh <= 8'b00010000; // 12:00
            pm <= 0;
        end else if (ena) begin
            if (hh == 12 && pm == 1'b0) begin
                hh <= 8'b00010001; // 01:00
                pm <= 1'b1;
            end else if (hh == 12 && pm == 1'b1) begin
                hh <= 8'b00010000; // 12:00
                pm <= 1'b0;
            end else if (hh[3:0] == 9) begin
                hh[7:4] <= hh[7:4] + 1;
                hh[3:0] <= 0;
            end else begin
                hh[3:0] <= hh[3:0] + 1;
            end
        end
    end

endmodule

module TopModule(clk, reset, ena, pm, hh, mm, ss);
    input clk, reset, ena;
    output pm;
    output [7:0] hh;
    output [7:0] mm;
    output [7:0] ss;
    reg pm;
    reg [7:0] hh;
    reg [7:0] mm;
    reg [7:0] ss;

    seconds_counter sc(clk, reset, ena, ss);
    minutes_counter mc(clk, reset, ena, mm);
    hours_counter hc(clk, reset, ena, pm, hh);

endmodule