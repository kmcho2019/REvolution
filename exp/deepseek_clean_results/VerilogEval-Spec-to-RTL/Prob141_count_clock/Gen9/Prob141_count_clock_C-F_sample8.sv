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
    reg [7:0] ss_reg;  // BCD seconds [7:4] = tens, [3:0] = units
    reg [7:0] mm_reg;  // BCD minutes
    reg [7:0] hh_reg;  // BCD hours

    wire ss_roll = (ss_reg == 8'h59);
    wire mm_roll = (mm_reg == 8'h59);
    wire hh_12   = (hh_reg == 8'h12);
    wire hh_11   = (hh_reg == 8'h11);

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            ss_reg <= 8'h00;
            mm_reg <= 8'h00;
            hh_reg <= 8'h12;
            pm_reg <= 0;
        end
        else if (ena) begin
            // Seconds counter
            if (ss_reg[3:0] == 4'h9) begin
                ss_reg[3:0] <= 0;
                if (ss_reg[7:4] == 4'h5) begin
                    ss_reg[7:4] <= 0;
                    
                    // Minutes counter
                    if (mm_reg[3:0] == 4'h9) begin
                        mm_reg[3:0] <= 0;
                        if (mm_reg[7:4] == 4'h5) begin
                            mm_reg[7:4] <= 0;
                            
                            // Hours counter - optimized logic
                            if (hh_12) begin
                                hh_reg <= 8'h01;
                            end
                            else if (hh_reg[3:0] == 4'h9) begin
                                hh_reg <= {hh_reg[7:4] + 1, 4'h0};
                            end
                            else begin
                                hh_reg[3:0] <= hh_reg[3:0] + 1;
                            end
                            
                            // PM toggle logic
                            if (hh_11) pm_reg <= ~pm_reg;
                        end
                        else begin
                            mm_reg[7:4] <= mm_reg[7:4] + 1;
                        end
                    end
                    else begin
                        mm_reg[3:0] <= mm_reg[3:0] + 1;
                    end
                end
                else begin
                    ss_reg[7:4] <= ss_reg[7:4] + 1;
                end
            end
            else begin
                ss_reg[3:0] <= ss_reg[3:0] + 1;
            end
        end
    end

    // Direct output assignments
    assign pm = pm_reg;
    assign ss = ss_reg;
    assign mm = mm_reg;
    assign hh = hh_reg;

endmodule