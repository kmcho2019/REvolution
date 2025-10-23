module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Internal registers
    reg [3:0] sec_ones;
    reg [2:0] sec_tens;
    reg [3:0] min_ones;
    reg [2:0] min_tens;
    reg [3:0] hour;    // 1-12 counter

    // Continuous output assignments
    assign ss = {sec_tens, 1'b0, sec_ones};  // Packed BCD (tens in bits 7:4)
    assign mm = {min_tens, 1'b0, min_ones};  // Packed BCD (tens in bits 7:4)
    assign pm = (hour >= 4'd12);             // PM when hour is 12-11

    // BCD hour output generation
    wire [3:0] hr_tens = (hour > 4'd9) ? 4'd1 : 4'd0;
    wire [3:0] hr_ones = (hour > 4'd9) ? hour - 4'd10 : hour;
    assign hh = {hr_tens, hr_ones};

    // Single always block for all counters
    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            sec_ones <= 4'd0;
            sec_tens <= 3'd0;
            min_ones <= 4'd0;
            min_tens <= 3'd0;
            hour <= 4'd12;
        end
        else if (ena) begin
            // Seconds counter
            if (sec_ones == 4'd9) begin
                sec_ones <= 4'd0;
                if (sec_tens == 3'd5) begin
                    sec_tens <= 3'd0;
                    
                    // Minutes counter
                    if (min_ones == 4'd9) begin
                        min_ones <= 4'd0;
                        if (min_tens == 3'd5) begin
                            min_tens <= 3'd0;
                            
                            // Hours counter
                            if (hour == 4'd12)
                                hour <= 4'd1;
                            else
                                hour <= hour + 1;
                        end
                        else begin
                            min_tens <= min_tens + 1;
                        end
                    end
                    else begin
                        min_ones <= min_ones + 1;
                    end
                end
                else begin
                    sec_tens <= sec_tens + 1;
                end
            end
            else begin
                sec_ones <= sec_ones + 1;
            end
        end
    end

endmodule