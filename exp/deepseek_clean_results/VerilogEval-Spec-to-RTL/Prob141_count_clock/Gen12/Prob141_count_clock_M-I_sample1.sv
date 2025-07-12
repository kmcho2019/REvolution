module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Constants for BCD values
    parameter ZERO = 4'd0;
    parameter NINE = 4'd9;
    parameter FIVE = 4'd5;
    parameter TWELVE = 4'd12;
    parameter ELEVEN = 4'd11;

    // Counter registers with Gray coding for hour
    reg [3:0] sec_ones, sec_tens;
    reg [3:0] min_ones, min_tens;
    reg [3:0] hour_gray;  // Gray coded hour (1-12)
    reg [1:0] hour_phase; // Tracks AM/PM state

    // Registered enable signals
    reg sec_inc_r, min_inc_r, hour_inc_r;
    
    // Pre-computed comparison terms
    wire sec_max = (sec_ones == NINE) && (sec_tens == FIVE);
    wire min_max = (min_ones == NINE) && (min_tens == FIVE);
    
    // Enable generation (registered to break critical path)
    always @(posedge clk) begin
        sec_inc_r <= ena;
        min_inc_r <= ena && sec_max;
        hour_inc_r <= ena && sec_max && min_max;
    end

    // Gray to binary conversion for hour
    function [3:0] gray_to_bin;
        input [3:0] gray;
        begin
            gray_to_bin[3] = gray[3];
            gray_to_bin[2] = gray[3] ^ gray[2];
            gray_to_bin[1] = gray[3] ^ gray[2] ^ gray[1];
            gray_to_bin[0] = gray[3] ^ gray[2] ^ gray[1] ^ gray[0];
        end
    endfunction

    // Binary to Gray conversion for hour
    function [3:0] bin_to_gray;
        input [3:0] bin;
        begin
            bin_to_gray[3] = bin[3];
            bin_to_gray[2] = bin[3] ^ bin[2];
            bin_to_gray[1] = bin[2] ^ bin[1];
            bin_to_gray[0] = bin[1] ^ bin[0];
        end
    endfunction

    // Current hour in binary (combinational)
    wire [3:0] hour_bin = gray_to_bin(hour_gray);

    // Seconds counter (00-59)
    always @(posedge clk) begin
        if (reset) begin
            sec_ones <= ZERO;
            sec_tens <= ZERO;
        end else if (sec_inc_r) begin
            if (sec_ones == NINE) begin
                sec_ones <= ZERO;
                sec_tens <= (sec_tens == FIVE) ? ZERO : sec_tens + 1;
            end else begin
                sec_ones <= sec_ones + 1;
            end
        end
    end

    // Minutes counter (00-59)
    always @(posedge clk) begin
        if (reset) begin
            min_ones <= ZERO;
            min_tens <= ZERO;
        end else if (min_inc_r) begin
            if (min_ones == NINE) begin
                min_ones <= ZERO;
                min_tens <= (min_tens == FIVE) ? ZERO : min_tens + 1;
            end else begin
                min_ones <= min_ones + 1;
            end
        end
    end

    // Hours counter (1-12) with Gray coding
    always @(posedge clk) begin
        if (reset) begin
            hour_gray <= bin_to_gray(TWELVE);
            hour_phase <= 2'b00; // AM state
        end else if (hour_inc_r) begin
            if (hour_bin == TWELVE) begin
                hour_gray <= bin_to_gray(4'd1);
            end else if (hour_bin == ELEVEN) begin
                hour_gray <= bin_to_gray(TWELVE);
                hour_phase <= ~hour_phase; // Toggle AM/PM
            end else begin
                hour_gray <= bin_to_gray(hour_bin + 1);
            end
        end
    end

    // Clock-gated BCD conversion
    reg [7:0] hh_reg, mm_reg, ss_reg;
    always @(posedge clk) begin
        if (ena || reset) begin
            // Seconds and minutes BCD (direct mapping)
            ss_reg <= {sec_tens, sec_ones};
            mm_reg <= {min_tens, min_ones};
            
            // Hour BCD conversion
            hh_reg <= (hour_bin > 4'd9) ? {4'd1, hour_bin - 4'd10} : {4'd0, hour_bin};
        end
    end

    // Output assignments
    assign pm = hour_phase[0]; // PM when phase is odd
    assign ss = ss_reg;
    assign mm = mm_reg;
    assign hh = hh_reg;

endmodule