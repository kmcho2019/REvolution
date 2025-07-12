module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // Separate BCD digits for seconds, minutes, and hours
    reg [3:0] ss_u, ss_t;
    reg [3:0] mm_u, mm_t;
    reg [3:0] hh_u, hh_t;

    // Function to increment a BCD digit with max limit and output carry
    function automatic [4:0] bcd_inc_digit_carry(input [3:0] digit, input [3:0] max);
        reg [4:0] result; // bit 4 is carry, bits 3:0 is new digit
        begin
            if (digit == max) begin
                result = {1'b1, 4'd0}; // carry out, digit rolls over
            end else begin
                result = {1'b0, digit + 4'd1};
            end
            bcd_inc_digit_carry = result;
        end
    endfunction

    // Function to increment seconds or minutes (00-59)
    function automatic [8:0] bcd_inc_59_carry(input [7:0] val);
        reg [4:0] u; // units inc + carry
        reg [4:0] t; // tens inc + carry
        reg [3:0] units, tens;
        begin
            units = val[3:0];
            tens = val[7:4];
            u = bcd_inc_digit_carry(units,4'd9);
            if (u[4]) begin // units rolled over, increment tens
                t = bcd_inc_digit_carry(tens,4'd5);
                bcd_inc_59_carry = {t[4], t[3:0], u[3:0]};
            end else begin
                bcd_inc_59_carry = {1'b0, tens, u[3:0]};
            end
        end
    endfunction

    // Function to increment 12-hour BCD hour (01-12)
    function automatic [8:0] hour_inc_carry(input [7:0] val);
        // return {carry, new_val}
        reg [3:0] tens, units;
        reg [7:0] result;
        reg       carry_out;
        begin
            tens = val[7:4];
            units = val[3:0];
            carry_out = 1'b0;

            if (val == 8'h12) begin
                result = 8'h01; // roll over 12->1
                carry_out = 1'b1; // indicate hour rollover from 12 to 1 (for completeness)
            end else if (val == 8'h09) begin
                result = 8'h10; // 09->10
            end else begin
                // increment units, roll tens if needed
                if (units == 4'd9) begin
                    units = 4'd0;
                    tens = tens + 4'd1;
                end else begin
                    units = units + 4'd1;
                end
                result = {tens, units};
            end

            hour_inc_carry = {carry_out, result};
        end
    endfunction

    // Detect hour rollover from 11 to 12 (needed to toggle PM)
    wire hour_is_11 = (hh_t == 4'd1 && hh_u == 4'd1);
    wire hour_is_12 = (hh_t == 4'd1 && hh_u == 4'd2);

    always @(posedge clk) begin
        if (reset) begin
            // Reset all digits and pm flag to 12:00:00 AM
            hh_t <= 4'd1;
            hh_u <= 4'd2;
            mm_t <= 4'd0;
            mm_u <= 4'd0;
            ss_t <= 4'd0;
            ss_u <= 4'd0;
            pm   <= 1'b0; // AM
        end else if (ena) begin
            // Increment seconds with carry chain
            // Step 1: increment seconds units
            {ss_t, ss_u} = {ss_t, ss_u}; // to prevent latches
            {ss_t, ss_u} = {ss_t, ss_u}; // Defensive, unnecessary but consistent

            // Increment seconds units
            // Use function with carry output
            reg [4:0] ss_u_inc;
            reg [4:0] ss_t_inc;
            reg       ss_t_carry;

            ss_u_inc = bcd_inc_digit_carry(ss_u,4'd9);
            if (ss_u_inc[4]) begin
                ss_u <= ss_u_inc[3:0];
                ss_t_inc = bcd_inc_digit_carry(ss_t,4'd5);
                ss_t_carry = ss_t_inc[4];
                ss_t <= ss_t_inc[3:0];
            end else begin
                ss_u <= ss_u_inc[3:0];
                ss_t_carry = 1'b0;
            end

            // If seconds rolled over (ss_t_carry), increment minutes similarly
            if (ss_t_carry) begin
                reg [4:0] mm_u_inc;
                reg [4:0] mm_t_inc;
                reg       mm_t_carry;

                mm_u_inc = bcd_inc_digit_carry(mm_u,4'd9);
                if (mm_u_inc[4]) begin
                    mm_u <= mm_u_inc[3:0];
                    mm_t_inc = bcd_inc_digit_carry(mm_t,4'd5);
                    mm_t_carry = mm_t_inc[4];
                    mm_t <= mm_t_inc[3:0];
                end else begin
                    mm_u <= mm_u_inc[3:0];
                    mm_t_carry = 1'b0;
                end

                // If minutes rolled over, increment hours
                if (mm_t_carry) begin
                    reg [8:0] hh_inc_result;
                    hh_inc_result = hour_inc_carry({hh_t, hh_u});
                    hh_t <= hh_inc_result[7:4];
                    hh_u <= hh_inc_result[3:0];
                    // Toggle PM if hour rolls from 11->12
                    if (hour_is_11) begin
                        pm <= ~pm;
                    end
                end
            end
        end
    end

    // Concatenate output ports combinationally
    always @(*) begin
        hh = {hh_t, hh_u};
        mm = {mm_t, mm_u};
        ss = {ss_t, ss_u};
    end

endmodule