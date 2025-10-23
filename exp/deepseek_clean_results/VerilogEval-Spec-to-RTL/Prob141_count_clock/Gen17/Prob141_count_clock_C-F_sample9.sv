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
    reg [7:0] ss_reg;  // BCD seconds [7:4] = tens, [3:0] = ones
    reg [7:0] mm_reg;  // BCD minutes
    reg [7:0] hh_reg;  // BCD hours (01-12)
    
    // Registered rollover flags
    reg ss_roll, mm_roll;
    
    // Seconds counter (BCD)
    always @(posedge clk) begin
        if (reset) begin
            ss_reg <= 8'h00;
            ss_roll <= 1'b0;
        end else if (ena) begin
            if (ss_reg[3:0] == 4'd9) begin
                ss_reg[3:0] <= 4'd0;
                if (ss_reg[7:4] == 4'd5) begin
                    ss_reg[7:4] <= 4'd0;
                    ss_roll <= 1'b1;
                end else begin
                    ss_reg[7:4] <= ss_reg[7:4] + 1;
                    ss_roll <= 1'b0;
                end
            end else begin
                ss_reg[3:0] <= ss_reg[3:0] + 1;
                ss_roll <= 1'b0;
            end
        end else begin
            ss_roll <= 1'b0;
        end
    end

    // Minutes counter (BCD)
    always @(posedge clk) begin
        if (reset) begin
            mm_reg <= 8'h00;
            mm_roll <= 1'b0;
        end else if (ena && ss_roll) begin
            if (mm_reg[3:0] == 4'd9) begin
                mm_reg[3:0] <= 4'd0;
                if (mm_reg[7:4] == 4'd5) begin
                    mm_reg[7:4] <= 4'd0;
                    mm_roll <= 1'b1;
                end else begin
                    mm_reg[7:4] <= mm_reg[7:4] + 1;
                    mm_roll <= 1'b0;
                end
            end else begin
                mm_reg[3:0] <= mm_reg[3:0] + 1;
                mm_roll <= 1'b0;
            end
        end else begin
            mm_roll <= 1'b0;
        end
    end

    // Hours counter (BCD)
    always @(posedge clk) begin
        if (reset) begin
            hh_reg <= 8'h12;
        end else if (ena && mm_roll) begin
            if (hh_reg == 8'h12) begin
                hh_reg <= 8'h01;
            end else if (hh_reg[3:0] == 4'd9) begin
                hh_reg <= {hh_reg[7:4] + 1, 4'd0};
            end else begin
                hh_reg[3:0] <= hh_reg[3:0] + 1;
            end
        end
    end

    // PM toggle logic
    always @(posedge clk) begin
        if (reset) begin
            pm_reg <= 1'b0;
        end else if (ena && mm_roll && (hh_reg == 8'h11)) begin
            pm_reg <= ~pm_reg;
        end
    end

    // Output assignments
    assign pm = pm_reg;
    assign ss = ss_reg;
    assign mm = mm_reg;
    assign hh = hh_reg;

endmodule