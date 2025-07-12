module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    reg pm_reg;
    reg [3:0] hour;       // hours (1-12)
    reg [3:0] mm_lo, ss_lo;  // low digits (0-9)
    reg [2:0] mm_hi, ss_hi;  // high digits (0-5)
    reg [1:0] state;      // 0: idle, 1: sec inc, 2: min inc, 3: hour inc

    // Pre-computed hour BCD values
    wire [7:0] hour_bcd [1:12];
    assign hour_bcd[1]  = 8'h01;
    assign hour_bcd[2]  = 8'h02;
    assign hour_bcd[3]  = 8'h03;
    assign hour_bcd[4]  = 8'h04;
    assign hour_bcd[5]  = 8'h05;
    assign hour_bcd[6]  = 8'h06;
    assign hour_bcd[7]  = 8'h07;
    assign hour_bcd[8]  = 8'h08;
    assign hour_bcd[9]  = 8'h09;
    assign hour_bcd[10] = 8'h10;
    assign hour_bcd[11] = 8'h11;
    assign hour_bcd[12] = 8'h12;

    // Single always block for all counters
    always @(posedge clk) begin
        if (reset) begin
            hour <= 4'd12;
            pm_reg <= 0;
            {mm_hi, mm_lo} <= 0;
            {ss_hi, ss_lo} <= 0;
            state <= 0;
        end else if (ena) begin
            case (state)
                0: state <= 1;  // Start counting
                
                1: begin  // Second increment
                    if (ss_lo == 9) begin
                        ss_lo <= 0;
                        if (ss_hi == 5) begin
                            ss_hi <= 0;
                            state <= 2;  // Move to minute increment
                        end else begin
                            ss_hi <= ss_hi + 1;
                            state <= 0;  // Back to idle
                        end
                    end else begin
                        ss_lo <= ss_lo + 1;
                        state <= 0;  // Back to idle
                    end
                end
                
                2: begin  // Minute increment
                    if (mm_lo == 9) begin
                        mm_lo <= 0;
                        if (mm_hi == 5) begin
                            mm_hi <= 0;
                            state <= 3;  // Move to hour increment
                        end else begin
                            mm_hi <= mm_hi + 1;
                            state <= 0;  // Back to idle
                        end
                    end else begin
                        mm_lo <= mm_lo + 1;
                        state <= 0;  // Back to idle
                    end
                end
                
                3: begin  // Hour increment
                    if (hour == 12) begin
                        hour <= 1;
                    end else begin
                        hour <= hour + 1;
                        if (hour == 11) pm_reg <= ~pm_reg;
                    end
                    state <= 0;  // Back to idle
                end
            endcase
        end
    end

    // Output assignments
    assign pm = pm_reg;
    assign ss = {1'b0, ss_hi, ss_lo};
    assign mm = {1'b0, mm_hi, mm_lo};
    assign hh = hour_bcd[hour];

endmodule