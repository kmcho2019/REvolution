module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // State definitions
    typedef enum logic [1:0] {IDLE, COUNT, ROLLOVER} counter_state_t;
    
    // Time component registers
    reg [3:0] ss_ones, ss_tens;
    reg [3:0] mm_ones, mm_tens;
    reg [3:0] hh_ones, hh_tens;
    reg pm_reg;
    
    // State machines
    counter_state_t ss_state, mm_state, hh_state;
    
    // Rollover signals
    wire ss_rollover = (ss_state == ROLLOVER);
    wire mm_rollover = (mm_state == ROLLOVER);
    
    // Output assignments
    assign pm = pm_reg;
    assign ss = {ss_tens, ss_ones};
    assign mm = {mm_tens, mm_ones};
    assign hh = {hh_tens, hh_ones};
    
    // Seconds counter state machine
    always @(posedge clk) begin
        if (reset) begin
            ss_state <= IDLE;
            ss_ones <= 4'd0;
            ss_tens <= 4'd0;
        end else begin
            case (ss_state)
                IDLE: if (ena) ss_state <= COUNT;
                COUNT: begin
                    if (ss_ones == 4'd9) begin
                        ss_ones <= 4'd0;
                        if (ss_tens == 4'd5) begin
                            ss_tens <= 4'd0;
                            ss_state <= ROLLOVER;
                        end else begin
                            ss_tens <= ss_tens + 1;
                        end
                    end else begin
                        ss_ones <= ss_ones + 1;
                    end
                    if (!ena) ss_state <= IDLE;
                end
                ROLLOVER: begin
                    ss_state <= IDLE;
                end
            endcase
        end
    end
    
    // Minutes counter state machine
    always @(posedge clk) begin
        if (reset) begin
            mm_state <= IDLE;
            mm_ones <= 4'd0;
            mm_tens <= 4'd0;
        end else begin
            case (mm_state)
                IDLE: if (ena && ss_rollover) mm_state <= COUNT;
                COUNT: begin
                    if (mm_ones == 4'd9) begin
                        mm_ones <= 4'd0;
                        if (mm_tens == 4'd5) begin
                            mm_tens <= 4'd0;
                            mm_state <= ROLLOVER;
                        end else begin
                            mm_tens <= mm_tens + 1;
                        end
                    end else begin
                        mm_ones <= mm_ones + 1;
                    end
                    if (!(ena && ss_rollover)) mm_state <= IDLE;
                end
                ROLLOVER: begin
                    mm_state <= IDLE;
                end
            endcase
        end
    end
    
    // Hours counter and PM state machine
    always @(posedge clk) begin
        if (reset) begin
            hh_state <= IDLE;
            hh_ones <= 4'd2;
            hh_tens <= 4'd1;
            pm_reg <= 1'b0;
        end else begin
            case (hh_state)
                IDLE: if (ena && ss_rollover && mm_rollover) hh_state <= COUNT;
                COUNT: begin
                    // Special handling for 12-hour clock
                    if ({hh_tens, hh_ones} == 8'h12) begin
                        hh_tens <= 4'd0;
                        hh_ones <= 4'd1;
                    end else if (hh_ones == 4'd9) begin
                        hh_tens <= hh_tens + 1;
                        hh_ones <= 4'd0;
                    end else begin
                        hh_ones <= hh_ones + 1;
                    end
                    
                    // PM toggle logic
                    if ({hh_tens, hh_ones} == 8'h11) begin
                        pm_reg <= ~pm_reg;
                    end
                    
                    hh_state <= IDLE;
                end
            endcase
        end
    end

endmodule