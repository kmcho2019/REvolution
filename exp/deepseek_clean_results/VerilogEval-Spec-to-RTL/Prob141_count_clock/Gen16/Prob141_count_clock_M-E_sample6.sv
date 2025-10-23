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
    typedef enum logic [1:0] {
        IDLE,
        SEC_INC,
        MIN_INC,
        HOUR_INC
    } state_t;

    state_t current_state, next_state;

    // Time registers in BCD format
    reg [7:0] ss_reg;  // seconds: tens(7:4), ones(3:0)
    reg [7:0] mm_reg;  // minutes: tens(7:4), ones(3:0)
    reg [7:0] hh_reg;  // hours: tens(7:4), ones(3:0)
    reg pm_reg;

    // Shared BCD increment logic
    function [7:0] bcd_inc;
        input [7:0] bcd;
        begin
            if (bcd[3:0] == 4'd9) begin
                bcd_inc[3:0] = 4'd0;
                bcd_inc[7:4] = bcd[7:4] + 1;
            end else begin
                bcd_inc = bcd + 1;
            end
        end
    endfunction

    // State machine and counter control
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            ss_reg <= 8'h00;
            mm_reg <= 8'h00;
            hh_reg <= 8'h12;  // 12:00:00 AM
            pm_reg <= 1'b0;
        end else begin
            current_state <= next_state;

            case (current_state)
                SEC_INC: begin
                    ss_reg <= (ss_reg == 8'h59) ? 8'h00 : bcd_inc(ss_reg);
                end
                MIN_INC: begin
                    mm_reg <= (mm_reg == 8'h59) ? 8'h00 : bcd_inc(mm_reg);
                end
                HOUR_INC: begin
                    if (hh_reg == 8'h11) pm_reg <= ~pm_reg;
                    hh_reg <= (hh_reg == 8'h12) ? 8'h01 : bcd_inc(hh_reg);
                end
                default: ; // IDLE state does nothing
            endcase
        end
    end

    // Next state logic
    always_comb begin
        next_state = IDLE;
        if (ena) begin
            case (current_state)
                IDLE: next_state = SEC_INC;
                SEC_INC: next_state = (ss_reg == 8'h59) ? MIN_INC : IDLE;
                MIN_INC: next_state = (mm_reg == 8'h59) ? HOUR_INC : IDLE;
                HOUR_INC: next_state = IDLE;
            endcase
        end
    end

    // Output assignments
    assign ss = ss_reg;
    assign mm = mm_reg;
    assign hh = hh_reg;
    assign pm = pm_reg;

endmodule