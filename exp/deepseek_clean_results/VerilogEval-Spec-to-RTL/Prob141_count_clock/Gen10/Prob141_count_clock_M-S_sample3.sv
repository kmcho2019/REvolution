module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    reg [3:0] sec_ones, sec_tens;
    reg [3:0] min_ones, min_tens;
    reg [3:0] hour_tens, hour_ones;  // Direct BCD storage (01-12)

    // Seconds counter (00-59 BCD)
    always @(posedge clk) begin
        if (reset) begin
            sec_ones <= 4'd0;
            sec_tens <= 4'd0;
        end else if (ena) begin
            if (sec_ones == 4'd9) begin
                sec_ones <= 4'd0;
                sec_tens <= (sec_tens == 4'd5) ? 4'd0 : sec_tens + 1;
            end else begin
                sec_ones <= sec_ones + 1;
            end
        end
    end

    // Minutes counter (00-59 BCD)
    always @(posedge clk) begin
        if (reset) begin
            min_ones <= 4'd0;
            min_tens <= 4'd0;
        end else if (ena && sec_ones == 4'd9 && sec_tens == 4'd5) begin
            if (min_ones == 4'd9) begin
                min_ones <= 4'd0;
                min_tens <= (min_tens == 4'd5) ? 4'd0 : min_tens + 1;
            end else begin
                min_ones <= min_ones + 1;
            end
        end
    end

    // Hours counter (01-12 BCD)
    always @(posedge clk) begin
        if (reset) begin
            hour_tens <= 4'd1;
            hour_ones <= 4'd2;
        end else if (ena && sec_ones == 4'd9 && sec_tens == 4'd5 && 
                    min_ones == 4'd9 && min_tens == 4'd5) begin
            if (hour_tens == 4'd1 && hour_ones == 4'd2) begin
                hour_tens <= 4'd0;
                hour_ones <= 4'd1;
            end else if (hour_ones == 4'd9) begin
                hour_ones <= 4'd0;
                hour_tens <= hour_tens + 1;
            end else begin
                hour_ones <= hour_ones + 1;
            end
        end
    end

    // Output assignments
    assign ss = {sec_tens, sec_ones};
    assign mm = {min_tens, min_ones};
    assign hh = {hour_tens, hour_ones};
    assign pm = (hour_tens == 4'd1 && hour_ones != 4'd2) ||  // 10, 11 AM
               (hour_tens == 4'd0 && hour_ones >= 4'd1);     // 1-9 PM (12 is special)

endmodule