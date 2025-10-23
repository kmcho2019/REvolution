module TopModule (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // define constants
    localparam [7:0] ZERO = 8'b0000_0000; // 00
    localparam [7:0] MAX_SEC = 8'b0000_0111; // 59
    localparam [7:0] MAX_MIN = 8'b0000_0111; // 59
    localparam [7:0] MAX_HR = 8'b0001_0010; // 12
    localparam [7:0] MAX_HR_PM = 8'b0001_0011; // 13 (for PM mode)

    // internal variables
    reg [7:0] sec;
    reg [7:0] min;
    reg [7:0] hr;

    // BCD increment function
    function [7:0] bcd_increment;
        input [7:0] value;
        reg [7:0] result;
        begin
            if (value[3:0] == 4'd9) begin
                result[3:0] = 4'd0;
                if (value[7:4] == 4'd5) begin
                    result[7:4] = 4'd0;
                end else begin
                    result[7:4] = value[7:4] + 1;
                end
            end else begin
                result = value + 1;
            end
            bcd_increment = result;
        end
    endfunction

    // sequential logic
    always @(posedge clk) begin
        if (reset) begin
            // reset all counters
            sec <= ZERO;
            min <= ZERO;
            hr <= 8'b0001_0010; // 12
            pm <= 1'b0;
        end else if (ena) begin
            // increment seconds counter
            if (sec == MAX_SEC) begin
                sec <= ZERO;
                // increment minutes counter
                if (min == MAX_MIN) begin
                    min <= ZERO;
                    // increment hours counter
                    if (hr == MAX_HR_PM) begin
                        hr <= 8'b0001_0000; // 8
                        pm <= 1'b0;
                    end else if (hr == MAX_HR) begin
                        hr <= 8'b0001_0001; // 9
                        pm <= 1'b1;
                    end else begin
                        hr <= bcd_increment(hr);
                        if (hr == MAX_HR) begin
                            pm <= 1'b1;
                        end
                    end
                end else begin
                    min <= bcd_increment(min);
                end
            end else begin
                sec <= bcd_increment(sec);
            end
        end
    end

    // assign outputs
    assign hh = hr;
    assign mm = min;
    assign ss = sec;

endmodule