module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Counter registers
    reg [7:0] ss_reg;  // BCD seconds (00-59)
    reg [7:0] mm_reg;  // BCD minutes (00-59)
    reg [3:0] hour;    // Binary hour (1-12)
    reg pm_reg;        // PM indicator

    // Internal enable signals
    wire sec_inc = ena;
    wire min_inc = ena && (ss_reg == 8'h59);
    wire hour_inc = min_inc && (mm_reg == 8'h59);

    // Seconds counter (00-59)
    always @(posedge clk) begin
        if (reset) begin
            ss_reg <= 8'h00;
        end else if (sec_inc) begin
            if (ss_reg[3:0] == 4'h9) begin
                ss_reg[3:0] <= 4'h0;
                ss_reg[7:4] <= (ss_reg[7:4] == 4'h5) ? 4'h0 : ss_reg[7:4] + 1;
            end else begin
                ss_reg[3:0] <= ss_reg[3:0] + 1;
            end
        end
    end

    // Minutes counter (00-59)
    always @(posedge clk) begin
        if (reset) begin
            mm_reg <= 8'h00;
        end else if (min_inc) begin
            if (mm_reg[3:0] == 4'h9) begin
                mm_reg[3:0] <= 4'h0;
                mm_reg[7:4] <= (mm_reg[7:4] == 4'h5) ? 4'h0 : mm_reg[7:4] + 1;
            end else begin
                mm_reg[3:0] <= mm_reg[3:0] + 1;
            end
        end
    end

    // Hours counter (1-12) and PM indicator
    always @(posedge clk) begin
        if (reset) begin
            hour <= 4'd12;
            pm_reg <= 1'b0;
        end else if (hour_inc) begin
            if (hour == 4'd12) begin
                hour <= 4'd1;
            end else begin
                hour <= hour + 1;
            end
            
            // Toggle PM at 11->12 transition
            if (hour == 4'd11) pm_reg <= ~pm_reg;
        end
    end

    // BCD conversion for hours (combinational)
    wire [3:0] hr_tens = (hour > 4'd9) ? 4'd1 : 4'd0;
    wire [3:0] hr_ones = (hour > 4'd9) ? hour - 4'd10 : hour;

    // Output assignments
    assign pm = pm_reg;
    assign hh = {hr_tens, hr_ones};
    assign mm = mm_reg;
    assign ss = ss_reg;

endmodule