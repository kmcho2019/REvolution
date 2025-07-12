module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Counter registers (all in BCD format)
    reg [7:0] ss_reg;  // seconds (00-59)
    reg [7:0] mm_reg;  // minutes (00-59)
    reg [7:0] hh_reg;  // hours (01-12)
    reg [0:0] am_pm;   // 0=AM, 1=PM

    // BCD increment logic
    wire [7:0] next_ss = (ss_reg[3:0] == 4'h9) ? 
                         {ss_reg[7:4] + (ss_reg[7:4] == 4'h5 ? 4'h1 : 4'h0), 4'h0} : 
                         {ss_reg[7:4], ss_reg[3:0] + 4'h1};

    wire [7:0] next_mm = (mm_reg[3:0] == 4'h9) ? 
                         {mm_reg[7:4] + (mm_reg[7:4] == 4'h5 ? 4'h1 : 4'h0), 4'h0} : 
                         {mm_reg[7:4], mm_reg[3:0] + 4'h1};

    wire [7:0] next_hh = (hh_reg == 8'h12) ? 8'h01 : 
                         {hh_reg[7:4], hh_reg[3:0] + 4'h1};

    // Enable conditions
    wire sec_ena = ena;
    wire min_ena = ena && (ss_reg == 8'h59);
    wire hour_ena = min_ena && (mm_reg == 8'h59);

    // Single always block for all counters
    always @(posedge clk) begin
        if (reset) begin
            ss_reg <= 8'h00;
            mm_reg <= 8'h00;
            hh_reg <= 8'h12;
            am_pm <= 1'b0;
        end else begin
            // Seconds counter
            if (sec_ena) begin
                ss_reg <= (ss_reg == 8'h59) ? 8'h00 : next_ss;
            end

            // Minutes counter
            if (min_ena) begin
                mm_reg <= (mm_reg == 8'h59) ? 8'h00 : next_mm;
            end

            // Hours counter
            if (hour_ena) begin
                hh_reg <= next_hh;
                // Toggle AM/PM at 11->12 transition
                if (hh_reg == 8'h11) am_pm <= ~am_pm;
            end
        end
    end

    // Output assignments
    assign pm = am_pm;
    assign hh = hh_reg;
    assign mm = mm_reg;
    assign ss = ss_reg;

endmodule