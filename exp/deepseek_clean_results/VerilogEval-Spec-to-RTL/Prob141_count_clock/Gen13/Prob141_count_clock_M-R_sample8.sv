module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Seconds counter (separate tens/ones)
    reg [3:0] ss_ones;
    reg [3:0] ss_tens;
    
    // Minutes counter (separate tens/ones)
    reg [3:0] mm_ones;
    reg [3:0] mm_tens;
    
    // Hour state machine (one-hot encoding)
    reg [11:0] hour_state;
    reg pm_reg;
    
    // Rollover signals (registered)
    reg sec_rollover;
    reg min_rollover;
    
    // Continuous output assignments
    assign ss = {ss_tens, ss_ones};
    assign mm = {mm_tens, mm_ones};
    assign pm = pm_reg;
    
    // Hour to BCD conversion (combinational)
    wire [3:0] hr_tens = (hour_state[11] | hour_state[10] | hour_state[9]) ? 4'd1 : 4'd0;
    wire [3:0] hr_ones = 
        hour_state[0]  ? 4'd1 :
        hour_state[1]  ? 4'd2 :
        hour_state[2]  ? 4'd3 :
        hour_state[3]  ? 4'd4 :
        hour_state[4]  ? 4'd5 :
        hour_state[5]  ? 4'd6 :
        hour_state[6]  ? 4'd7 :
        hour_state[7]  ? 4'd8 :
        hour_state[8]  ? 4'd9 :
        hour_state[9]  ? 4'd0 : // 10
        hour_state[10] ? 4'd1 : // 11
                         4'd2;  // 12
    assign hh = {hr_tens, hr_ones};
    
    // Seconds counter logic
    always @(posedge clk) begin
        if (reset) begin
            ss_ones <= 4'd0;
            ss_tens <= 4'd0;
            sec_rollover <= 1'b0;
        end else if (ena) begin
            sec_rollover <= (ss_ones == 4'd9) && (ss_tens == 4'd5);
            
            if (ss_ones == 4'd9) begin
                ss_ones <= 4'd0;
                ss_tens <= (ss_tens == 4'd5) ? 4'd0 : ss_tens + 1;
            end else begin
                ss_ones <= ss_ones + 1;
            end
        end
    end
    
    // Minutes counter logic
    always @(posedge clk) begin
        if (reset) begin
            mm_ones <= 4'd0;
            mm_tens <= 4'd0;
            min_rollover <= 1'b0;
        end else if (ena && sec_rollover) begin
            min_rollover <= (mm_ones == 4'd9) && (mm_tens == 4'd5) && sec_rollover;
            
            if (mm_ones == 4'd9) begin
                mm_ones <= 4'd0;
                mm_tens <= (mm_tens == 4'd5) ? 4'd0 : mm_tens + 1;
            end else begin
                mm_ones <= mm_ones + 1;
            end
        end
    end
    
    // Hour state machine
    always @(posedge clk) begin
        if (reset) begin
            hour_state <= 12'b000000000001; // 12 o'clock
            pm_reg <= 1'b0;
        end else if (ena && sec_rollover && min_rollover) begin
            // State transitions
            hour_state <= {hour_state[10:0], hour_state[11]};
            
            // Toggle PM at 11->12 transition
            if (hour_state[10]) begin // 11 o'clock
                pm_reg <= ~pm_reg;
            end
        end
    end

endmodule