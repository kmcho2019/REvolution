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
    reg [5:0] sec_bin;    // 0-59 in binary
    reg [5:0] min_bin;    // 0-59 in binary
    reg [4:0] hour_bin;   // 0-23 in binary (for simpler PM detection)
    
    wire sec_ena = ena;
    wire min_ena = ena & (sec_bin == 6'd59);
    wire hour_ena = min_ena & (min_bin == 6'd59);
    
    // State encoding for 12-hour format
    localparam H12_AM = 2'b00;
    localparam H12_PM = 2'b01;
    localparam H12_12 = 2'b10;
    
    reg [1:0] hour_state;
    reg [3:0] hour_digit;
    
    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            sec_bin <= 6'd0;
            min_bin <= 6'd0;
            hour_bin <= 5'd0;
            pm_reg <= 1'b0;
            hour_state <= H12_12;
            hour_digit <= 4'd12;
        end else begin
            // Seconds counter
            if (sec_ena) begin
                sec_bin <= (sec_bin == 6'd59) ? 6'd0 : sec_bin + 1;
            end
            
            // Minutes counter
            if (min_ena) begin
                min_bin <= (min_bin == 6'd59) ? 6'd0 : min_bin + 1;
            end
            
            // Hours counter and PM detection
            if (hour_ena) begin
                hour_bin <= (hour_bin == 5'd23) ? 5'd0 : hour_bin + 1;
                
                // Update 12-hour format
                case (hour_state)
                    H12_AM: begin
                        if (hour_bin == 5'd10) begin
                            hour_state <= H12_11;
                            hour_digit <= 4'd11;
                        end else if (hour_bin == 5'd11) begin
                            hour_state <= H12_12;
                            hour_digit <= 4'd12;
                        end else begin
                            hour_digit <= hour_bin[3:0] + 1;
                        end
                    end
                    H12_PM: begin
                        if (hour_bin == 5'd22) begin
                            hour_state <= H12_11;
                            hour_digit <= 4'd11;
                        end else if (hour_bin == 5'd23) begin
                            hour_state <= H12_12;
                            hour_digit <= 4'd12;
                        end else begin
                            hour_digit <= hour_bin[3:0] - 4'd11;
                        end
                    end
                    H12_12: begin
                        if (hour_bin == 5'd11) begin
                            hour_state <= H12_PM;
                            pm_reg <= 1'b1;
                            hour_digit <= 4'd12;
                        end else if (hour_bin == 5'd23) begin
                            hour_state <= H12_AM;
                            pm_reg <= 1'b0;
                            hour_digit <= 4'd12;
                        end else begin
                            hour_digit <= 4'd1;
                            hour_state <= (hour_bin < 5'd11) ? H12_AM : H12_PM;
                        end
                    end
                    default: begin
                        hour_digit <= 4'd1;
                        hour_state <= H12_AM;
                    end
                endcase
            end
        end
    end
    
    // Binary to BCD conversion
    function [7:0] bin2bcd;
        input [5:0] bin;
        reg [3:0] tens;
        reg [3:0] ones;
    begin
        tens = bin / 6'd10;
        ones = bin % 6'd10;
        bin2bcd = {tens, ones};
    end
    endfunction
    
    // Hour digit to BCD (always 1 or 2 digits)
    wire [3:0] hour_tens = (hour_digit > 4'd9) ? 4'd1 : 4'd0;
    wire [3:0] hour_ones = (hour_digit > 4'd9) ? hour_digit - 4'd10 : hour_digit;
    
    assign pm = pm_reg;
    assign hh = {hour_tens, hour_ones};
    assign mm = bin2bcd(min_bin);
    assign ss = bin2bcd(sec_bin);

endmodule