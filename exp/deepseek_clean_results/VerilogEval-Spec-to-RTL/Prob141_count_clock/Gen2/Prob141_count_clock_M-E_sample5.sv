module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Digit registers (each digit is 4 bits)
    reg [3:0] hh_tens, hh_ones;
    reg [3:0] mm_tens, mm_ones;
    reg [3:0] ss_tens, ss_ones;
    reg pm_reg;

    // State machine states
    typedef enum logic [2:0] {
        IDLE,
        INC_SEC,
        INC_MIN,
        INC_HOUR,
        TOGGLE_AMPM
    } state_t;
    state_t state, next_state;

    // Next digit values
    wire [3:0] next_ss_ones = (ss_ones == 4'h9) ? 4'h0 : ss_ones + 1;
    wire [3:0] next_ss_tens = (ss_ones == 4'h9) ? 
                             ((ss_tens == 4'h5) ? 4'h0 : ss_tens + 1) : 
                             ss_tens;
    
    wire [3:0] next_mm_ones = (mm_ones == 4'h9) ? 4'h0 : mm_ones + 1;
    wire [3:0] next_mm_tens = (mm_ones == 4'h9) ? 
                             ((mm_tens == 4'h5) ? 4'h0 : mm_tens + 1) : 
                             mm_tens;

    wire [3:0] next_hh_ones = (hh_ones == 4'h9) ? 4'h0 : hh_ones + 1;
    wire [3:0] next_hh_tens = (hh_ones == 4'h9) ? hh_tens + 1 : hh_tens;
    wire hour_rollover = (hh_tens == 4'h1 && hh_ones == 4'h2);

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            hh_tens <= 4'h1;
            hh_ones <= 4'h2;
            mm_tens <= 4'h0;
            mm_ones <= 4'h0;
            ss_tens <= 4'h0;
            ss_ones <= 4'h0;
            pm_reg <= 1'b0;
            state <= IDLE;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: if (ena) state <= INC_SEC;
                
                INC_SEC: begin
                    ss_ones <= next_ss_ones;
                    ss_tens <= next_ss_tens;
                    if (ss_ones == 4'h9 && ss_tens == 4'h5)
                        next_state <= INC_MIN;
                    else
                        next_state <= IDLE;
                end
                
                INC_MIN: begin
                    mm_ones <= next_mm_ones;
                    mm_tens <= next_mm_tens;
                    if (mm_ones == 4'h9 && mm_tens == 4'h5)
                        next_state <= INC_HOUR;
                    else
                        next_state <= IDLE;
                end
                
                INC_HOUR: begin
                    if (hour_rollover) begin
                        hh_tens <= 4'h0;
                        hh_ones <= 4'h1;
                        next_state <= TOGGLE_AMPM;
                    end else begin
                        hh_ones <= next_hh_ones;
                        hh_tens <= next_hh_tens;
                        next_state <= IDLE;
                    end
                end
                
                TOGGLE_AMPM: begin
                    pm_reg <= ~pm_reg;
                    next_state <= IDLE;
                end
            endcase
        end
    end

    // Output assignments
    assign pm = pm_reg;
    assign hh = {hh_tens, hh_ones};
    assign mm = {mm_tens, mm_ones};
    assign ss = {ss_tens, ss_ones};

endmodule