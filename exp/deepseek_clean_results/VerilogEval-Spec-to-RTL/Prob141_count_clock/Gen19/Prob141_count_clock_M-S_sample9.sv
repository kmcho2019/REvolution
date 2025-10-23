module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Counter registers (all in BCD format)
    reg [7:0] ss_reg;  // seconds (00-59)
    reg [7:0] mm_reg;  // minutes (00-59)
    reg [7:0] hh_reg;  // hours (01-12)
    reg pm_reg;        // PM indicator

    // Seconds counter (00-59)
    always @(posedge clk) begin
        if (reset) begin
            ss_reg <= 8'h00;
        end else if (ena) begin
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
        end else if (ena && ss_reg == 8'h59) begin
            if (mm_reg[3:0] == 4'h9) begin
                mm_reg[3:0] <= 4'h0;
                mm_reg[7:4] <= (mm_reg[7:4] == 4'h5) ? 4'h0 : mm_reg[7:4] + 1;
            end else begin
                mm_reg[3:0] <= mm_reg[3:0] + 1;
            end
        end
    end

    // Hours counter (01-12) and PM indicator
    always @(posedge clk) begin
        if (reset) begin
            hh_reg <= 8'h12;
            pm_reg <= 1'b0;
        end else if (ena && ss_reg == 8'h59 && mm_reg == 8'h59) begin
            if (hh_reg == 8'h12) begin
                hh_reg <= 8'h01;
            end else if (hh_reg[3:0] == 4'h9) begin
                hh_reg <= {hh_reg[7:4] + 1, 4'h0};
            end else begin
                hh_reg[3:0] <= hh_reg[3:0] + 1;
            end
            
            // Toggle PM at 11->12 transition
            if (hh_reg == 8'h11) pm_reg <= ~pm_reg;
        end
    end

    // Output assignments
    assign pm = pm_reg;
    assign hh = hh_reg;
    assign mm = mm_reg;
    assign ss = ss_reg;

endmodule