module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Counter registers
    reg [3:0] sec_ones, sec_tens;
    reg [3:0] min_ones, min_tens;
    reg [3:0] hour;  // 1-12 counter
    
    // Rollover signals (combinational)
    wire sec_rollover = (sec_ones == 4'd9) && (sec_tens == 4'd5);
    wire min_rollover = (min_ones == 4'd9) && (min_tens == 4'd5);
    
    // Increment enables (combinational)
    wire sec_inc = ena;
    wire min_inc = ena && sec_rollover;
    wire hour_inc = ena && sec_rollover && min_rollover;
    
    // Seconds counter (00-59)
    always @(posedge clk) begin
        if (reset) begin
            sec_ones <= 4'd0;
            sec_tens <= 4'd0;
        end else if (sec_inc) begin
            sec_ones <= (sec_ones == 4'd9) ? 4'd0 : sec_ones + 1;
            if (sec_ones == 4'd9) begin
                sec_tens <= (sec_tens == 4'd5) ? 4'd0 : sec_tens + 1;
            end
        end
    end

    // Minutes counter (00-59)
    always @(posedge clk) begin
        if (reset) begin
            min_ones <= 4'd0;
            min_tens <= 4'd0;
        end else if (min_inc) begin
            min_ones <= (min_ones == 4'd9) ? 4'd0 : min_ones + 1;
            if (min_ones == 4'd9) begin
                min_tens <= (min_tens == 4'd5) ? 4'd0 : min_tens + 1;
            end
        end
    end

    // Hours counter (1-12) with explicit state transitions
    always @(posedge clk) begin
        if (reset) begin
            hour <= 4'd12;
        end else if (hour_inc) begin
            case (hour)
                4'd12: hour <= 4'd1;
                default: hour <= hour + 1;
            endcase
        end
    end

    // PM indicator (combinational based on hour state)
    // PM is active when hour is 12-11 (12:00 PM to 11:59 PM)
    assign pm = (hour == 4'd12) ? 1'b1 : 
                (hour >= 4'd1 && hour <= 4'd11) ? ~pm : 1'b0;

    // BCD outputs (combinational)
    wire [3:0] hr_tens = (hour > 4'd9) ? 4'd1 : 4'd0;
    wire [3:0] hr_ones = (hour > 4'd9) ? hour - 4'd10 : hour;

    assign ss = {sec_tens, sec_ones};
    assign mm = {min_tens, min_ones};
    assign hh = {hr_tens, hr_ones};

endmodule