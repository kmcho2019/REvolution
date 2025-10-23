module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    reg [5:0] sec;  // 0-59
    reg [5:0] min;  // 0-59
    reg [4:0] hour; // 0-23

    always @(posedge clk) begin
        if (reset) begin
            sec <= 0;
            min <= 0;
            hour <= 12; // 12 AM
        end else if (ena) begin
            // Seconds counter
            if (sec == 59) begin
                sec <= 0;
                // Minutes counter
                if (min == 59) begin
                    min <= 0;
                    // Hours counter
                    if (hour == 23)
                        hour <= 0;
                    else
                        hour <= hour + 1;
                end else begin
                    min <= min + 1;
                end
            end else begin
                sec <= sec + 1;
            end
        end
    end

    // Convert binary to BCD for outputs
    function [7:0] bin2bcd;
        input [5:0] bin;
        begin
            bin2bcd = {4'd0, bin[5:0]}; // Tens digit is 0-5
            if (bin2bcd[3:0] > 4'd9) begin
                bin2bcd[3:0] = bin2bcd[3:0] - 4'd10;
                bin2bcd[7:4] = bin2bcd[7:4] + 1;
            end
        end
    endfunction

    // Convert 24-hour to 12-hour format
    wire [4:0] hour12 = (hour == 0) ? 5'd12 : 
                       (hour > 12) ? hour - 12 : hour;
    wire hour_tens = (hour12 >= 10);

    assign ss = bin2bcd(sec);
    assign mm = bin2bcd(min);
    assign hh = {3'b0, hour_tens, hour12[3:0]};
    assign pm = (hour >= 12);

endmodule