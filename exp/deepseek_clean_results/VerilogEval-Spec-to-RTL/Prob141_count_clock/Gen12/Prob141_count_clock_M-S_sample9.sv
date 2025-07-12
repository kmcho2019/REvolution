module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    reg pm_reg;
    reg [7:0] ss_reg;
    reg [7:0] mm_reg;
    reg [7:0] hh_reg;

    // Seconds counter
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

    // Minutes counter
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

    // Hours and PM counter
    always @(posedge clk) begin
        if (reset) begin
            hh_reg <= 8'h12;
            pm_reg <= 1'b0;
        end else if (ena && ss_reg == 8'h59 && mm_reg == 8'h59) begin
            if (hh_reg == 8'h12) begin
                hh_reg <= 8'h01;
            end else begin
                if (hh_reg[3:0] == 4'h9) begin
                    hh_reg <= {4'h1, 4'h0};
                end else begin
                    hh_reg[3:0] <= hh_reg[3:0] + 1;
                end
            end
            
            // Toggle PM at 11->12 transition
            if (hh_reg == 8'h11) pm_reg <= ~pm_reg;
        end
    end

    assign pm = pm_reg;
    assign hh = hh_reg;
    assign mm = mm_reg;
    assign ss = ss_reg;

endmodule