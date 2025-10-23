module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    reg [5:0] seconds; // 0-59
    reg [5:0] minutes; // 0-59
    reg [3:0] hours;   // 1-12

    always @(posedge clk) begin
        if (reset) begin
            pm      <= 1'b0;
            seconds <= 6'd0;
            minutes <= 6'd0;
            hours   <= 4'd12;
        end else if (ena) begin
            if (seconds == 6'd59) begin
                seconds <= 6'd0;
                if (minutes == 6'd59) begin
                    minutes <= 6'd0;
                    if (hours == 4'd11) begin
                        hours <= 4'd12;
                        pm <= ~pm;
                    end else if (hours == 4'd12) begin
                        hours <= 4'd1;
                    end else begin
                        hours <= hours + 1;
                    end
                end else begin
                    minutes <= minutes + 1;
                end
            end else begin
                seconds <= seconds + 1;
            end
        end
    end

    // Combinational BCD digit extraction by subtraction (no function)
    always @(*) begin
        // Seconds tens and units
        if (seconds >= 50) ss[7:4] = 4'd5;
        else if (seconds >= 40) ss[7:4] = 4'd4;
        else if (seconds >= 30) ss[7:4] = 4'd3;
        else if (seconds >= 20) ss[7:4] = 4'd2;
        else if (seconds >= 10) ss[7:4] = 4'd1;
        else                  ss[7:4] = 4'd0;
        ss[3:0] = seconds - (ss[7:4]*10);

        // Minutes tens and units
        if (minutes >= 50) mm[7:4] = 4'd5;
        else if (minutes >= 40) mm[7:4] = 4'd4;
        else if (minutes >= 30) mm[7:4] = 4'd3;
        else if (minutes >= 20) mm[7:4] = 4'd2;
        else if (minutes >= 10) mm[7:4] = 4'd1;
        else                   mm[7:4] = 4'd0;
        mm[3:0] = minutes - (mm[7:4]*10);

        // Hours tens and units (hours range 1-12)
        if (hours >= 10) hh[7:4] = 4'd1;
        else             hh[7:4] = 4'd0;
        hh[3:0] = hours - (hh[7:4]*10);
    end

endmodule