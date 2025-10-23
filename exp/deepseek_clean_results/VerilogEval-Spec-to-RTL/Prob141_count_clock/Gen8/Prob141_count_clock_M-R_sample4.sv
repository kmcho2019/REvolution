module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Parameters for reset values
    parameter SEC_RESET = 8'h00;
    parameter MIN_RESET = 8'h00;
    parameter HR_RESET = 8'h12;
    parameter PM_RESET = 1'b0;

    // Seconds counter (BCD 00-59)
    reg [7:0] sec_bcd;
    wire sec_ena = ena;
    wire sec_roll = (sec_bcd == 8'h59);

    always @(posedge clk) begin
        if (reset) sec_bcd <= SEC_RESET;
        else if (sec_ena) begin
            if (sec_roll) sec_bcd <= 8'h00;
            else if (sec_bcd[3:0] == 4'h9) begin
                sec_bcd[3:0] <= 4'h0;
                sec_bcd[7:4] <= sec_bcd[7:4] + 1;
            end else begin
                sec_bcd[3:0] <= sec_bcd[3:0] + 1;
            end
        end
    end

    // Minutes counter (BCD 00-59)
    reg [7:0] min_bcd;
    wire min_ena = sec_ena & sec_roll;
    wire min_roll = (min_bcd == 8'h59);

    always @(posedge clk) begin
        if (reset) min_bcd <= MIN_RESET;
        else if (min_ena) begin
            if (min_roll) min_bcd <= 8'h00;
            else if (min_bcd[3:0] == 4'h9) begin
                min_bcd[3:0] <= 4'h0;
                min_bcd[7:4] <= min_bcd[7:4] + 1;
            end else begin
                min_bcd[3:0] <= min_bcd[3:0] + 1;
            end
        end
    end

    // Hours counter (binary 1-12)
    reg [3:0] hr_bin;
    wire hr_ena = min_ena & min_roll;
    wire hr_roll = (hr_bin == 4'd12);

    always @(posedge clk) begin
        if (reset) hr_bin <= HR_RESET[3:0];
        else if (hr_ena) begin
            if (hr_roll) hr_bin <= 4'd1;
            else hr_bin <= hr_bin + 1;
        end
    end

    // PM indicator (toggles at 11->12 transition)
    reg pm_reg;
    always @(posedge clk) begin
        if (reset) pm_reg <= PM_RESET;
        else if (hr_ena && hr_bin == 4'd11) pm_reg <= ~pm_reg;
    end

    // Convert binary hour to BCD
    wire [7:0] hr_bcd = (hr_bin < 10) ? {4'h0, hr_bin} : {4'h1, hr_bin - 4'd10};

    // Output assignments
    assign ss = sec_bcd;
    assign mm = min_bcd;
    assign hh = hr_bcd;
    assign pm = pm_reg;

endmodule