module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE,
        INC_SEC,
        INC_MIN,
        INC_HOUR
    } state_t;

    state_t current_state, next_state;
    
    // Time registers in BCD format
    reg [7:0] hh_reg, mm_reg, ss_reg;
    reg pm_reg;
    
    // Next value computation
    wire [7:0] next_ss = bcd_increment(ss_reg, 8'h59);
    wire [7:0] next_mm = bcd_increment(mm_reg, 8'h59);
    wire [7:0] next_hh;
    wire next_pm;
    
    // Special hour increment logic
    assign {next_pm, next_hh} = hour_increment(hh_reg, pm_reg);
    
    // BCD increment function
    function [7:0] bcd_increment(input [7:0] val, input [7:0] max);
        if (val[3:0] == 4'h9) begin
            if (val[7:4] == max[7:4]) begin
                bcd_increment = 8'h00;  // Roll over
            end else begin
                bcd_increment = {val[7:4] + 1, 4'h0};
            end
        end else begin
            bcd_increment = {val[7:4], val[3:0] + 1};
        end
    endfunction
    
    // Special hour increment with AM/PM toggle
    function [8:0] hour_increment(input [7:0] hh, input pm);
        reg [8:0] result;
        if (hh == 8'h12) begin
            result = {~pm, 8'h01};  // Toggle AM/PM and set to 1
        end else if (hh[3:0] == 4'h9) begin
            result = {pm, hh[7:4] + 1, 4'h0};  // Increment tens digit
        end else begin
            result = {pm, hh[7:4], hh[3:0] + 1};  // Increment ones digit
        end
        return result;
    endfunction
    
    // State machine
    always @(posedge clk) begin
        if (reset) begin
            hh_reg <= 8'h12;
            mm_reg <= 8'h00;
            ss_reg <= 8'h00;
            pm_reg <= 1'b0;
            current_state <= IDLE;
        end else begin
            case (current_state)
                IDLE: begin
                    if (ena) current_state <= INC_SEC;
                end
                INC_SEC: begin
                    ss_reg <= next_ss;
                    current_state <= (ss_reg == 8'h59) ? INC_MIN : IDLE;
                end
                INC_MIN: begin
                    mm_reg <= next_mm;
                    current_state <= (mm_reg == 8'h59) ? INC_HOUR : IDLE;
                end
                INC_HOUR: begin
                    hh_reg <= next_hh;
                    pm_reg <= next_pm;
                    current_state <= IDLE;
                end
            endcase
        end
    end
    
    assign pm = pm_reg;
    assign hh = hh_reg;
    assign mm = mm_reg;
    assign ss = ss_reg;

endmodule