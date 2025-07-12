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
    reg [5:0] sec_count;  // 0-59 in binary
    reg [5:0] min_count;  // 0-59 in binary
    reg [4:0] hour_count; // 0-23 in binary (for easier AM/PM tracking)
    
    wire sec_overflow = (sec_count == 6'd59) & ena;
    wire min_overflow = (min_count == 6'd59) & sec_overflow;
    
    // Binary to BCD conversion functions
    function [7:0] bin_to_bcd;
        input [5:0] bin;
        begin
            bin_to_bcd[3:0] = bin % 10;
            bin_to_bcd[7:4] = bin / 10;
        end
    endfunction
    
    function [7:0] hour_to_bcd;
        input [4:0] hour;
        reg [4:0] h12;
        begin
            h12 = (hour == 0) ? 12 : (hour > 12) ? hour - 12 : hour;
            hour_to_bcd[3:0] = h12 % 10;
            hour_to_bcd[7:4] = h12 / 10;
        end
    endfunction

    // Seconds counter
    always @(posedge clk) begin
        if (reset) sec_count <= 0;
        else if (ena) begin
            sec_count <= (sec_count == 6'd59) ? 0 : sec_count + 1;
        end
    end

    // Minutes counter
    always @(posedge clk) begin
        if (reset) min_count <= 0;
        else if (sec_overflow) begin
            min_count <= (min_count == 6'd59) ? 0 : min_count + 1;
        end
    end

    // Hours and PM counter
    always @(posedge clk) begin
        if (reset) begin
            hour_count <= 0;
            pm_reg <= 0;
        end
        else if (min_overflow) begin
            if (hour_count == 5'd23) begin
                hour_count <= 0;
                pm_reg <= 0;
            end else begin
                hour_count <= hour_count + 1;
                if (hour_count == 5'd11) pm_reg <= ~pm_reg;
            end
        end
    end

    // Output assignments
    assign pm = pm_reg;
    assign ss = bin_to_bcd(sec_count);
    assign mm = bin_to_bcd(min_count);
    assign hh = hour_to_bcd(hour_count);

endmodule