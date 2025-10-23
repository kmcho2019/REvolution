module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // Separate BCD digits for each time element:
    // Hours tens (0 or 1), Hours units (1 to 9 or 0 to 2 depending on tens)
    // Minutes tens (0-5), Minutes units (0-9)
    // Seconds tens (0-5), Seconds units (0-9)
    
    reg [3:0] ss_ones, ss_tens;
    reg [3:0] mm_ones, mm_tens;
    reg [3:0] hh_ones, hh_tens;

    // Helper task for incrementing BCD digit with carry
    function automatic [4:0] bcd_increment;
        input [3:0] digit;
        input [3:0] max_val;
        reg [4:0] res; // 5 bits to carry overflow
    begin
        if (digit == max_val) begin
            res = 5'd0; // reset digit and carry 1
        end else begin
            res = digit + 1;
        end
        bcd_increment = res;
    end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            // Reset clock to 12:00:00 AM
            pm      <= 1'b0;
            hh_tens <= 4'd1;
            hh_ones <= 4'd2;
            mm_tens <= 4'd0;
            mm_ones <= 4'd0;
            ss_tens <= 4'd0;
            ss_ones <= 4'd0;
        end else if (ena) begin
            // Seconds increment
            // Increment seconds ones, if overflow increment tens, if overflow increment minutes...
            if (ss_ones == 4'd9) begin
                ss_ones <= 4'd0;
                if (ss_tens == 4'd5) begin
                    ss_tens <= 4'd0;
                    // Increment minutes
                    if (mm_ones == 4'd9) begin
                        mm_ones <= 4'd0;
                        if (mm_tens == 4'd5) begin
                            mm_tens <= 4'd0;
                            // Increment hours
                            if ((hh_tens == 4'd1 && hh_ones == 4'd2)) begin
                                // Transition from 12 to 1
                                hh_tens <= 4'd0;
                                hh_ones <= 4'd1;
                                pm <= ~pm;
                            end else if (hh_tens == 4'd0 && hh_ones == 4'd9) begin
                                // From 09 to 10
                                hh_tens <= 4'd1;
                                hh_ones <= 4'd0;
                            end else begin
                                // Normal increment of hours units
                                if (hh_ones == 4'd9) begin
                                    hh_ones <= 4'd0; // should not occur since max hour is 12
                                end else begin
                                    hh_ones <= hh_ones + 1;
                                end
                            end
                        end else begin
                            mm_tens <= mm_tens + 1;
                        end
                    end else begin
                        mm_ones <= mm_ones + 1;
                    end
                end else begin
                    ss_tens <= ss_tens + 1;
                end
            end else begin
                ss_ones <= ss_ones + 1;
            end
        end
    end

    // Combine the BCD digits to output ports continuously
    always @(*) begin
        hh = {hh_tens, hh_ones};
        mm = {mm_tens, mm_ones};
        ss = {ss_tens, ss_ones};
    end

endmodule