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
    reg [5:0] sec;      // 0-59 binary
    reg [5:0] min;      // 0-59 binary
    reg [4:0] hour_bin; // 1-12 binary
    
    // State encoding for timekeeping
    typedef enum logic [1:0] {
        IDLE,
        SEC_INC,
        MIN_INC,
        HOUR_INC
    } state_t;
    
    state_t state;

    // BCD conversion through continuous assignments
    assign ss = {sec[5:4], sec[3:0] + (sec[3:0] > 9 ? 6 : 0)};
    assign mm = {min[5:4], min[3:0] + (min[3:0] > 9 ? 6 : 0)};
    assign hh = (hour_bin > 12) ? 8'h12 : 
               (hour_bin == 0) ? 8'h12 :
               {4'd0, hour_bin[3:0] + (hour_bin[3:0] > 9 ? 6 : 0)};
    assign pm = pm_reg;

    // Unified state machine for timekeeping
    always @(posedge clk) begin
        if (reset) begin
            sec <= 0;
            min <= 0;
            hour_bin <= 12;
            pm_reg <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (ena) state <= SEC_INC;
                end
                
                SEC_INC: begin
                    sec <= (sec == 59) ? 0 : sec + 1;
                    state <= (sec == 59) ? MIN_INC : IDLE;
                end
                
                MIN_INC: begin
                    min <= (min == 59) ? 0 : min + 1;
                    state <= (min == 59) ? HOUR_INC : IDLE;
                end
                
                HOUR_INC: begin
                    if (hour_bin == 12) begin
                        hour_bin <= 1;
                    end else begin
                        hour_bin <= hour_bin + 1;
                    end
                    
                    if (hour_bin == 11) pm_reg <= ~pm_reg;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule