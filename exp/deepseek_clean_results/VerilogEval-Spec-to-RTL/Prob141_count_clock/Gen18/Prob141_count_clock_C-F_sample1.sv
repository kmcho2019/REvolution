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
    reg pm_reg;
    reg [3:0] hour;        // Binary hour (1-12)
    reg [3:0] ss_tens;     // Seconds tens (0-5)
    reg [3:0] ss_ones;     // Seconds ones (0-9)
    reg [3:0] mm_tens;     // Minutes tens (0-5)
    reg [3:0] mm_ones;     // Minutes ones (0-9)
    
    // Rollover detection (combinational)
    wire ss_roll = (ss_tens == 4'd5) && (ss_ones == 4'd9) && ena;
    wire mm_roll = (mm_tens == 4'd5) && (mm_ones == 4'd9) && ss_roll;
    
    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            {ss_tens, ss_ones} <= {4'd0, 4'd0};
        end else if (ena) begin
            if (ss_ones == 4'd9) begin
                ss_ones <= 4'd0;
                ss_tens <= (ss_tens == 4'd5) ? 4'd0 : ss_tens + 1;
            end else begin
                ss_ones <= ss_ones + 1;
            end
        end
    end

    // Minutes counter
    always @(posedge clk) begin
        if (reset) begin
            {mm_tens, mm_ones} <= {4'd0, 4'd0};
        end else if (ss_roll) begin
            if (mm_ones == 4'd9) begin
                mm_ones <= 4'd0;
                mm_tens <= (mm_tens == 4'd5) ? 4'd0 : mm_tens + 1;
            end else begin
                mm_ones <= mm_ones + 1;
            end
        end
    end

    // Hours and PM logic
    always @(posedge clk) begin
        if (reset) begin
            hour <= 4'd12;
            pm_reg <= 1'b0;
        end else if (mm_roll) begin
            if (hour == 4'd12) begin
                hour <= 4'd1;
            end else begin
                hour <= hour + 1;
            end
            
            // Toggle PM only when going from 11 to 12
            if (hour == 4'd11) pm_reg <= ~pm_reg;
        end
    end

    // Output registers for better timing
    reg [7:0] hh_reg, mm_reg, ss_reg;
    always @(posedge clk) begin
        // BCD conversion for hours (combinational)
        hh_reg <= {(hour > 4'd9) ? 4'd1 : 4'd0, (hour > 4'd9) ? hour - 4'd10 : hour};
        mm_reg <= {mm_tens, mm_ones};
        ss_reg <= {ss_tens, ss_ones};
    end

    // Output assignments
    assign pm = pm_reg;
    assign hh = hh_reg;
    assign mm = mm_reg;
    assign ss = ss_reg;

endmodule