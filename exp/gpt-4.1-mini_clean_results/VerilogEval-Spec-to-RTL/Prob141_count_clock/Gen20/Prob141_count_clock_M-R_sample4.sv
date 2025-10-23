module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,  // BCD hours (01-12)
    output reg [7:0]  mm,  // BCD minutes (00-59)
    output reg [7:0]  ss   // BCD seconds (00-59)
);

// Internal carry signals
reg sec_carry; 
reg min_carry;

// Seconds counter (BCD)
always @(posedge clk) begin
    if (reset) begin
        ss <= 8'h00;
        sec_carry <= 1'b0;
    end else if (ena) begin
        if (ss == 8'h59) begin
            ss <= 8'h00;
            sec_carry <= 1'b1;
        end else begin
            // Increment BCD seconds
            if (ss[3:0] == 4'd9) begin
                ss[3:0] <= 4'd0;
                ss[7:4] <= ss[7:4] + 4'd1;
            end else begin
                ss[3:0] <= ss[3:0] + 4'd1;
            end
            sec_carry <= 1'b0;
        end
    end else begin
        sec_carry <= 1'b0;
    end
end

// Minutes counter (BCD)
always @(posedge clk) begin
    if (reset) begin
        mm <= 8'h00;
        min_carry <= 1'b0;
    end else if (sec_carry) begin
        if (mm == 8'h59) begin
            mm <= 8'h00;
            min_carry <= 1'b1;
        end else begin
            // Increment BCD minutes
            if (mm[3:0] == 4'd9) begin
                mm[3:0] <= 4'd0;
                mm[7:4] <= mm[7:4] + 4'd1;
            end else begin
                mm[3:0] <= mm[3:0] + 4'd1;
            end
            min_carry <= 1'b0;
        end
    end else begin
        min_carry <= 1'b0;
    end
end

// Hours counter (BCD, 1-12)
always @(posedge clk) begin
    if (reset) begin
        hh <= 8'h12;  // 12 in BCD
        pm <= 1'b0;   // AM
    end else if (min_carry) begin
        // Convert current BCD hour to binary for arithmetic
        // Since hours run 1-12, we decode the BCD to binary integer:
        reg [3:0] hour_bin;
        hour_bin = (hh[7:4] == 4'd1) ? (4'd10 + hh[3:0]) : hh[3:0];

        // Increment hour
        if (hour_bin == 4'd12) begin
            hour_bin = 4'd1;
            pm <= ~pm; // Toggle am/pm at rollover 12->1
        end else begin
            hour_bin = hour_bin + 4'd1;
        end

        // Convert back to BCD
        if (hour_bin < 4'd10)
            hh <= {4'd0, hour_bin};
        else
            hh <= {4'd1, hour_bin - 4'd10};
    end
end

endmodule