module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // Internal binary counters
    reg [5:0] seconds; // 0-59
    reg [5:0] minutes; // 0-59
    reg [3:0] hours;   // 1-12

    always @(posedge clk) begin
        if (reset) begin
            seconds <= 6'd0;
            minutes <= 6'd0;
            hours   <= 4'd12;
            pm      <= 1'b0; // AM
        end else if (ena) begin
            if (seconds == 6'd59) begin
                seconds <= 6'd0;
                if (minutes == 6'd59) begin
                    minutes <= 6'd0;
                    if (hours == 4'd11) begin
                        hours <= 4'd12;
                        pm <= ~pm; // toggle PM at 11->12
                    end else if (hours == 4'd12) begin
                        hours <= 4'd1;
                    end else begin
                        hours <= hours + 4'd1;
                    end
                end else begin
                    minutes <= minutes + 6'd1;
                end
            end else begin
                seconds <= seconds + 6'd1;
            end
        end
    end

    // Combinational BCD conversion for minutes and seconds
    always @(*) begin
        // Seconds
        if (seconds >= 6'd50)       ss = {4'd5, seconds - 6'd50};
        else if (seconds >= 6'd40)  ss = {4'd4, seconds - 6'd40};
        else if (seconds >= 6'd30)  ss = {4'd3, seconds - 6'd30};
        else if (seconds >= 6'd20)  ss = {4'd2, seconds - 6'd20};
        else if (seconds >= 6'd10)  ss = {4'd1, seconds - 6'd10};
        else                        ss = {4'd0, seconds};

        // Minutes
        if (minutes >= 6'd50)       mm = {4'd5, minutes - 6'd50};
        else if (minutes >= 6'd40)  mm = {4'd4, minutes - 6'd40};
        else if (minutes >= 6'd30)  mm = {4'd3, minutes - 6'd30};
        else if (minutes >= 6'd20)  mm = {4'd2, minutes - 6'd20};
        else if (minutes >= 6'd10)  mm = {4'd1, minutes - 6'd10};
        else                        mm = {4'd0, minutes};

        // Hours (1-12)
        if (hours >= 4'd10) begin
            hh = {4'd1, hours - 4'd10};
        end else begin
            hh = {4'd0, hours};
        end
    end

endmodule