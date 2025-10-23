module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // State encoding: {pm, hr_tens[3:0], hr_ones[3:0], min_tens[3:0], min_ones[3:0], sec_tens[3:0], sec_ones[3:0]}
    reg [31:0] state;

    // Next state computation (parallel)
    wire [31:0] next_state;
    wire sec_inc, min_inc, hr_inc;
    wire [7:0] next_sec, next_min, next_hr;
    wire next_pm;

    // Seconds increment logic
    assign sec_inc = ena & ~reset;
    bcd_increment #(.MAX(59)) sec_incr (
        .bcd({state[7:4], state[3:0]}),
        .inc(sec_inc),
        .next_bcd(next_sec),
        .carry_out(min_inc)
    );

    // Minutes increment logic
    bcd_increment #(.MAX(59)) min_incr (
        .bcd({state[15:12], state[11:8]}),
        .inc(min_inc),
        .next_bcd(next_min),
        .carry_out(hr_inc)
    );

    // Hours increment logic with AM/PM toggle
    wire [7:0] hr_bcd = {state[23:20], state[19:16]};
    wire hr_rollover = (hr_bcd == 8'h11); // 11 -> 12
    wire hr_12to1 = (hr_bcd == 8'h12);    // 12 -> 1
    
    assign next_hr = hr_12to1 ? 8'h01 : 
                    hr_rollover ? 8'h12 : 
                    (hr_bcd[3:0] == 4'd9) ? {hr_bcd[7:4] + 1, 4'd0} : 
                    {hr_bcd[7:4], hr_bcd[3:0] + 1};
    
    assign next_pm = hr_rollover ? ~state[31] : state[31];

    // Next state assignment
    assign next_state = reset ? 32'h0_1_2_0_0_0_0 : // 12:00:00 AM
                      {next_pm, next_hr[7:4], next_hr[3:0], 
                       next_min[7:4], next_min[3:0],
                       next_sec[7:4], next_sec[3:0]};

    // State register
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output assignments
    assign pm = state[31];
    assign hh = {state[23:20], state[19:16]};
    assign mm = {state[15:12], state[11:8]};
    assign ss = {state[7:4], state[3:0]};

endmodule

// Parameterized BCD increment module with carry out
module bcd_increment #(
    parameter MAX = 59
) (
    input [7:0] bcd,
    input inc,
    output reg [7:0] next_bcd,
    output carry_out
);
    always @(*) begin
        if (inc) begin
            if (bcd[3:0] == 4'd9) begin
                next_bcd[3:0] = 4'd0;
                if (bcd[7:4] == (MAX/10)) begin
                    next_bcd[7:4] = 4'd0;
                end else begin
                    next_bcd[7:4] = bcd[7:4] + 1;
                end
            end else begin
                next_bcd = {bcd[7:4], bcd[3:0] + 1};
            end
        end else begin
            next_bcd = bcd;
        end
    end

    assign carry_out = inc & (bcd == MAX);
endmodule