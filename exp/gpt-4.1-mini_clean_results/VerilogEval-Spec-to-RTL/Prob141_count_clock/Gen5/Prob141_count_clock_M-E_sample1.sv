module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh, // BCD: {tens, units}
    output reg [7:0]  mm, // BCD: {tens, units}
    output reg [7:0]  ss  // BCD: {tens, units}
);

    // Seconds BCD digits
    reg [3:0] ss_ones;
    reg [3:0] ss_tens;

    // Minutes BCD digits
    reg [3:0] mm_ones;
    reg [3:0] mm_tens;

    // Hours BCD digits (01 to 12)
    reg [3:0] hh_ones;
    reg [3:0] hh_tens;

    // Increment seconds BCD counter
    // Returns carry_out: 1 if seconds rolled over (60)
    function automatic bit inc_seconds;
        input [3:0] st; // tens
        input [3:0] so; // ones
        output reg [3:0] st_out;
        output reg [3:0] so_out;
        begin
            // Increment ones digit
            if (so == 4'd9) begin
                so_out = 4'd0;
                // Increment tens digit
                if (st == 4'd5) begin
                    st_out = 4'd0;
                    inc_seconds = 1'b1; // rollover after 59->00
                end else begin
                    st_out = st + 1;
                    inc_seconds = 1'b0;
                end
            end else begin
                so_out = so + 1;
                st_out = st;
                inc_seconds = 1'b0;
            end
        end
    endfunction

    // Increment minutes BCD counter, same logic as seconds
    function automatic bit inc_minutes;
        input [3:0] mt; // tens
        input [3:0] mo; // ones
        output reg [3:0] mt_out;
        output reg [3:0] mo_out;
        begin
            // Increment ones digit
            if (mo == 4'd9) begin
                mo_out = 4'd0;
                if (mt == 4'd5) begin
                    mt_out = 4'd0;
                    inc_minutes = 1'b1; // rollover after 59->00
                end else begin
                    mt_out = mt + 1;
                    inc_minutes = 1'b0;
                end
            end else begin
                mo_out = mo + 1;
                mt_out = mt;
                inc_minutes = 1'b0;
            end
        end
    endfunction

    // Increment hours BCD counter (12-hour format, 01-12)
    // Returns carry_out: 1 if hour rolled over from 12 to 1 (to toggle pm)
    function automatic bit inc_hours;
        input [3:0] ht; // tens
        input [3:0] ho; // ones
        output reg [3:0] ht_out;
        output reg [3:0] ho_out;
        begin
            // Increment hour BCD digits
            if (ht == 4'd1 && ho == 4'd2) begin
                // 12 -> 1
                ht_out = 4'd0;
                ho_out = 4'd1;
                inc_hours = 1'b1;
            end else if (ho == 4'd9) begin
                // Ones rollover from 9 to 0 with tens increment
                ho_out = 4'd0;
                ht_out = ht + 1;
                inc_hours = 1'b0;
            end else begin
                ho_out = ho + 1;
                ht_out = ht;
                inc_hours = 1'b0;
            end
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            pm      <= 1'b0;         // AM
            ss_ones <= 4'd0;
            ss_tens <= 4'd0;
            mm_ones <= 4'd0;
            mm_tens <= 4'd0;
            hh_tens <= 4'd1;
            hh_ones <= 4'd2;         // 12
        end else if (ena) begin
            bit sec_roll, min_roll, hr_roll;

            // Increment seconds
            sec_roll = inc_seconds(ss_tens, ss_ones, ss_tens, ss_ones);

            if (sec_roll) begin
                // Increment minutes
                min_roll = inc_minutes(mm_tens, mm_ones, mm_tens, mm_ones);

                if (min_roll) begin
                    // Increment hours
                    hr_roll = inc_hours(hh_tens, hh_ones, hh_tens, hh_ones);
                    if (hr_roll) pm <= ~pm;
                end
            end
        end
    end

    always @(*) begin
        // Output concatenation: BCD digits already held as tens and ones
        hh = {hh_tens, hh_ones};
        mm = {mm_tens, mm_ones};
        ss = {ss_tens, ss_ones};
    end

endmodule