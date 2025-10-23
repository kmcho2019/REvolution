module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

// Internal registers for hours, minutes, and seconds
reg [3:0] hour_tens;
reg [3:0] hour_ones;
reg [3:0] min_tens;
reg [3:0] min_ones;
reg [3:0] sec_tens;
reg [3:0] sec_ones;
reg pm_reg;

// Assign outputs
assign hh = {4'b0, hour_tens, hour_ones};
assign mm = {4'b0, min_tens, min_ones};
assign ss = {4'b0, sec_tens, sec_ones};
assign pm = pm_reg;

always @(posedge clk) begin
    if (reset) begin
        // Reset clock to "12:00 AM"
        hour_tens <= 4'b0001;
        hour_ones <= 4'b0000;
        min_tens <= 4'b0000;
        min_ones <= 4'b0000;
        sec_tens <= 4'b0000;
        sec_ones <= 4'b0000;
        pm_reg <= 1'b0; // AM
    end else if (ena) begin
        // Increment seconds
        if (sec_ones == 4'b1001) begin
            sec_ones <= 4'b0000;
            if (sec_tens == 4'b0101) begin
                sec_tens <= 4'b0000;
                // Increment minutes
                if (min_ones == 4'b1001) begin
                    min_ones <= 4'b0000;
                    if (min_tens == 4'b0101) begin
                        min_tens <= 4'b0000;
                        // Increment hours
                        if ((hour_tens == 4'b0001 && hour_ones == 4'b0010) || (hour_tens == 4'b0001 && hour_ones == 4'b0011)) begin
                            hour_tens <= 4'b0000;
                            hour_ones <= 4'b0001;
                            pm_reg <= ~pm_reg; // Toggle AM/PM
                        end else begin
                            if (hour_ones == 4'b1001) begin
                                hour_ones <= 4'b0000;
                                if (hour_tens == 4'b0000) begin
                                    hour_tens <= 4'b0001;
                                end else if (hour_tens == 4'b0001) begin
                                    hour_tens <= 4'b0010;
                                end else begin
                                    hour_tens <= hour_tens + 1'b1;
                                end
                            end else begin
                                hour_ones <= hour_ones + 1'b1;
                            end
                        end
                    end else begin
                        min_tens <= min_tens + 1'b1;
                    end
                end else begin
                    min_ones <= min_ones + 1'b1;
                end
            end else begin
                sec_tens <= sec_tens + 1'b1;
            end
        end else begin
            sec_ones <= sec_ones + 1'b1;
        end
    end
end

endmodule