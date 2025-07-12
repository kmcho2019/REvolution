module TopModule(
    input clk, 
    input reset, 
    input ena, 
    output pm, 
    output [7:0] hh, 
    output [7:0] mm, 
    output [7:0] ss
    );

reg [7:0] hh_reg;
reg [7:0] mm_reg;
reg [7:0] ss_reg;
reg pm_reg;

// Initialize counters
initial begin
    hh_reg = 8'h12; // 12 in BCD
    mm_reg = 8'h00; // 0 in BCD
    ss_reg = 8'h00; // 0 in BCD
    pm_reg = 1'b0; // AM
end

// Synchronous reset
always @(posedge clk) begin
    if (reset) begin
        hh_reg <= 8'h12; // 12 in BCD
        mm_reg <= 8'h00; // 0 in BCD
        ss_reg <= 8'h00; // 0 in BCD
        pm_reg <= 1'b0; // AM
    end else if (ena) begin
        // Increment seconds
        if (ss_reg == 8'h59) begin // 59 in BCD
            ss_reg <= 8'h00; // 0 in BCD
            // Increment minutes
            if (mm_reg == 8'h59) begin // 59 in BCD
                mm_reg <= 8'h00; // 0 in BCD
                // Increment hours
                if (hh_reg == 8'h12 && pm_reg == 1'b1) begin // 12 PM
                    hh_reg <= 8'h01; // 1 in BCD
                    pm_reg <= 1'b0; // AM
                end else if (hh_reg == 8'h12 && pm_reg == 1'b0) begin // 12 AM
                    hh_reg <= 8'h01; // 1 in BCD
                    pm_reg <= 1'b1; // PM
                end else if (hh_reg >= 8'h01 && hh_reg < 8'h12) begin
                    // Increment hour
                    hh_reg <= hh_reg + 1;
                end else begin // 12 XX -> 1 XX
                    hh_reg <= 8'h01; // 1 in BCD
                    pm_reg <= ~pm_reg; // toggle AM/PM
                end
            end else begin // increment minutes
                mm_reg <= mm_reg + 1;
            end
        end else begin // increment seconds
            ss_reg <= ss_reg + 1;
        end
    end
end

// Assign outputs
assign hh = hh_reg;
assign mm = mm_reg;
assign ss = ss_reg;
assign pm = pm_reg;

endmodule