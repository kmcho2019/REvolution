module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Internal time representation (seconds since midnight)
    reg [31:0] time_counter;
    wire [31:0] next_time = (time_counter == 32'd43199) ? 32'd0 : time_counter + 1;

    // BCD conversion registers
    reg [7:0] hh_bcd, mm_bcd, ss_bcd;
    reg pm_reg;

    // BCD conversion pipeline registers
    reg [31:0] time_pipe1, time_pipe2;
    reg ena_pipe1, ena_pipe2;

    // Main counter and pipeline
    always @(posedge clk) begin
        if (reset) begin
            time_counter <= 32'd0;
            time_pipe1 <= 32'd0;
            time_pipe2 <= 32'd0;
            ena_pipe1 <= 1'b0;
            ena_pipe2 <= 1'b0;
        end else begin
            if (ena) time_counter <= next_time;
            time_pipe1 <= time_counter;
            time_pipe2 <= time_pipe1;
            ena_pipe1 <= ena;
            ena_pipe2 <= ena_pipe1;
        end
    end

    // BCD conversion logic (combinational)
    wire [31:0] current_time = ena_pipe2 ? time_pipe2 : time_pipe1;
    wire [7:0] sec_ones, sec_tens, min_ones, min_tens, hr_ones, hr_tens;

    // Seconds conversion
    assign sec_ones = (current_time % 60) % 10;
    assign sec_tens = (current_time % 60) / 10;

    // Minutes conversion
    assign min_ones = ((current_time / 60) % 60) % 10;
    assign min_tens = ((current_time / 60) % 60) / 10;

    // Hours conversion (12-hour format)
    wire [31:0] hours_raw = (current_time / 3600) % 12;
    assign hr_ones = (hours_raw == 0) ? 2 : (hours_raw % 10);
    assign hr_tens = (hours_raw == 0) ? 1 : (hours_raw / 10);

    // PM detection
    wire is_pm = (current_time >= 32'd21600) && (current_time < 32'd43200);

    // Output registers
    always @(posedge clk) begin
        if (reset) begin
            ss_bcd <= 8'h00;
            mm_bcd <= 8'h00;
            hh_bcd <= 8'h12;
            pm_reg <= 1'b0;
        end else if (ena_pipe2) begin
            ss_bcd <= {sec_tens[3:0], sec_ones[3:0]};
            mm_bcd <= {min_tens[3:0], min_ones[3:0]};
            hh_bcd <= {hr_tens[3:0], hr_ones[3:0]};
            pm_reg <= is_pm;
        end
    end

    // Output assignments
    assign pm = pm_reg;
    assign ss = ss_bcd;
    assign mm = mm_bcd;
    assign hh = hh_bcd;

endmodule