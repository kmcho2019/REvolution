module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// BCD increment for seconds and minutes: units digit 0-9, tens digit 0-5
function [7:0] bcd_inc_59(input [7:0] val);
    reg [3:0] units, tens;
    begin
        units = val[3:0];
        tens  = val[7:4];
        if (units == 4'd9) begin
            units = 4'd0;
            if (tens == 4'd5)
                tens = 4'd0;
            else
                tens = tens + 4'd1;
        end else begin
            units = units + 4'd1;
        end
        bcd_inc_59 = {tens, units};
    end
endfunction

// Check if bcd value is 59
function is_59(input [7:0] val);
    begin
        is_59 = (val == 8'h59);
    end
endfunction

// Increment hour in 12-hour BCD (01 to 12)
function [7:0] hour_inc(input [7:0] curr);
    reg [3:0] h_tens, h_units;
    begin
        h_tens  = curr[7:4];
        h_units = curr[3:0];
        if (curr == 8'h12)
            hour_inc = 8'h01;
        else if (curr == 8'h09)
            hour_inc = 8'h10; // 9 -> 10
        else begin
            // increment units digit
            if (h_units == 4'd9) begin
                h_units = 4'd0;
                h_tens = h_tens + 4'd1;
            end else begin
                h_units = h_units + 4'd1;
            end
            hour_inc = {h_tens, h_units};
        end
    end
endfunction

// Detect hour rollover for pm toggle: from 11 to 12
wire hour_rollover;
assign hour_rollover = (hh == 8'h11);

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        pm <= 1'b0;       // AM
        hh <= 8'h12;      // 12
        mm <= 8'h00;
        ss <= 8'h00;
    end else if (ena) begin
        if (is_59(ss)) begin
            ss <= 8'h00;
            if (is_59(mm)) begin
                mm <= 8'h00;
                if (hour_rollover) begin
                    hh <= 8'h12;
                    pm <= ~pm;
                end else begin
                    if (hh == 8'h12)
                        hh <= 8'h01;
                    else
                        hh <= hour_inc(hh);
                end
            end else begin
                mm <= bcd_inc_59(mm);
            end
        end else begin
            ss <= bcd_inc_59(ss);
        end
    end
end

endmodule