module TopModule (
    input        clk,
    input        reset,
    input        ena,
    output reg   pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Function: Increment a BCD digit with max value, returns {carry_out, new_digit}
    function [4:0] bcd_inc;
        input [3:0] digit;
        input [3:0] max_val;
        begin
            if (digit == max_val)
                bcd_inc = {1'b1, 4'd0};
            else
                bcd_inc = {1'b0, digit + 1};
        end
    endfunction

    // Convert BCD hour to integer (1 to 12)
    function [3:0] bcd_to_dec;
        input [7:0] bcd_in;
        begin
            bcd_to_dec = bcd_in[7:4]*4'd10 + bcd_in[3:0];
        end
    endfunction

    // Convert decimal to BCD 2-digit
    function [7:0] dec_to_bcd;
        input [3:0] dec_in; // Only valid 1..12 here
        begin
            dec_to_bcd = { (dec_in / 10), (dec_in % 10)};
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            pm <= 1'b0;
            hh <= 8'h12;  // 12 in BCD
            mm <= 8'h00;
            ss <= 8'h00;
        end else if (ena) begin
            // Increment seconds units
            reg carry_sec_u;
            reg carry_sec_t;
            reg carry_min_u;
            reg carry_min_t;
            reg [3:0] sec_u_next;
            reg [3:0] sec_t_next;
            reg [3:0] min_u_next;
            reg [3:0] min_t_next;
            reg [3:0] hour_u_next;
            reg [3:0] hour_t_next;

            // Current digits
            reg [3:0] sec_u = ss[3:0];
            reg [3:0] sec_t = ss[7:4];
            reg [3:0] min_u = mm[3:0];
            reg [3:0] min_t = mm[7:4];
            reg [3:0] hour_u = hh[3:0];
            reg [3:0] hour_t = hh[7:4];

            // Seconds units increment
            {carry_sec_u, sec_u_next} = bcd_inc(sec_u, 4'd9);
            sec_t_next = sec_t;
            min_u_next = min_u;
            min_t_next = min_t;
            hour_u_next = hour_u;
            hour_t_next = hour_t;
            carry_sec_t = 1'b0;
            carry_min_u = 1'b0;
            carry_min_t = 1'b0;

            if (carry_sec_u) begin
                // seconds units rolled over, increment seconds tens
                {carry_sec_t, sec_t_next} = bcd_inc(sec_t, 4'd5);
                if (carry_sec_t) begin
                    // seconds tens rolled over, increment minutes units
                    {carry_min_u, min_u_next} = bcd_inc(min_u, 4'd9);
                    if (carry_min_u) begin
                        // minutes units rolled over, increment minutes tens
                        {carry_min_t, min_t_next} = bcd_inc(min_t, 4'd5);
                        if (carry_min_t) begin
                            // minutes tens rolled over, increment hours
                            // Convert hour BCD to decimal
                            reg [3:0] h_dec;
                            h_dec = hour_t * 4'd10 + hour_u;
                            if (h_dec == 4'd11) begin
                                // 11 -> 12 toggles pm
                                h_dec = 4'd12;
                                pm <= ~pm;
                            end else if (h_dec == 4'd12) begin
                                // 12 -> 1 no pm toggle
                                h_dec = 4'd1;
                            end else begin
                                h_dec = h_dec + 4'd1;
                            end
                            hour_t_next = h_dec / 10;
                            hour_u_next = h_dec % 10;
                        end
                    end
                end
            end

            // Update all registers
            ss <= {sec_t_next, sec_u_next};
            mm <= {min_t_next, min_u_next};
            hh <= {hour_t_next, hour_u_next};
        end
    end

endmodule