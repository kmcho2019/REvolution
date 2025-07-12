module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Timekeeping registers
    reg [3:0] sec_ones, sec_tens;
    reg [3:0] min_ones, min_tens;
    reg [3:0] hour;  // 1-12 counter

    // Seconds counter (00-59)
    always @(posedge clk) begin
        if (reset) begin
            sec_ones <= 4'd0;
            sec_tens <= 4'd0;
            min_ones <= 4'd0;
            min_tens <= 4'd0;
            hour <= 4'd12;
        end
        else if (ena) begin
            // Seconds increment
            if (sec_ones == 4'd9) begin
                sec_ones <= 4'd0;
                if (sec_tens == 4'd5) begin
                    sec_tens <= 4'd0;
                    
                    // Minutes increment
                    if (min_ones == 4'd9) begin
                        min_ones <= 4'd0;
                        if (min_tens == 4'd5) begin
                            min_tens <= 4'd0;
                            
                            // Hours increment
                            case (hour)
                                4'd12: hour <= 4'd1;
                                default: hour <= hour + 1;
                            endcase
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

    // Output assignments
    assign pm = (hour < 4'd12) ? 1'b0 : 1'b1;  // PM from 12-11
    assign ss = {sec_tens, sec_ones};
    assign mm = {min_tens, min_ones};
    assign hh = (hour > 4'd9) ? {4'd1, hour - 4'd10} : {4'd0, hour};

endmodule