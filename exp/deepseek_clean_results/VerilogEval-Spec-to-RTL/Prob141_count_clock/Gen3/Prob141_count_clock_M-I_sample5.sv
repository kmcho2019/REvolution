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
    reg [5:0] sec_bin;    // 0-59
    reg [5:0] min_bin;    // 0-59
    reg [4:0] hour_bin;   // 0-23 (for simpler PM detection)
    wire sec_ena = ena && !reset;
    wire min_ena = sec_ena && (sec_bin == 6'd59);
    wire hour_ena = min_ena && (min_bin == 6'd59);

    // Binary counters
    always @(posedge clk) begin
        if (reset) begin
            sec_bin <= 6'd0;
            min_bin <= 6'd0;
            hour_bin <= 5'd0; // Will be converted to 12 AM
            pm_reg <= 1'b0;
        end else begin
            if (sec_ena) begin
                sec_bin <= (sec_bin == 6'd59) ? 6'd0 : sec_bin + 1;
            end
            
            if (min_ena) begin
                min_bin <= (min_bin == 6'd59) ? 6'd0 : min_bin + 1;
            end
            
            if (hour_ena) begin
                if (hour_bin == 5'd23) begin
                    hour_bin <= 5'd0;
                    pm_reg <= 1'b0;
                end else begin
                    hour_bin <= hour_bin + 1;
                    // Toggle PM at 11->12 transition
                    if (hour_bin == 5'd10) pm_reg <= 1'b1;
                    else if (hour_bin == 5'd22) pm_reg <= 1'b0;
                end
            end
        end
    end

    // BCD conversion
    wire [7:0] sec_bcd = {
        sec_bin[5:4] + (sec_bin[5:4] > 2'd5),  // Tens digit
        sec_bin[3:0] + (sec_bin[5:4] > 2'd5) ? 4'd6 : 4'd0  // Units digit
    };

    wire [7:0] min_bcd = {
        min_bin[5:4] + (min_bin[5:4] > 2'd5),  // Tens digit
        min_bin[3:0] + (min_bin[5:4] > 2'd5) ? 4'd6 : 4'd0  // Units digit
    };

    // Hour conversion (12-hour format)
    wire [4:0] hour_12 = (hour_bin == 5'd0) ? 5'd12 : 
                        (hour_bin > 5'd12) ? hour_bin - 5'd12 : hour_bin;
    wire [7:0] hour_bcd = {
        hour_12 > 5'd9 ? 4'd1 : 4'd0,  // Tens digit
        hour_12[3:0] + (hour_12 > 5'd9 ? 4'd6 : 4'd0)  // Units digit
    };

    assign pm = pm_reg;
    assign hh = hour_bcd;
    assign mm = min_bcd;
    assign ss = sec_bcd;

endmodule