module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Packed state register: [pm][hh_hi][hh_lo][mm_hi][mm_lo][ss_hi][ss_lo]
    reg [31:0] state;

    // State field definitions
    wire pm_reg = state[31];
    wire [3:0] hh_hi = state[30:27];
    wire [3:0] hh_lo = state[26:23];
    wire [3:0] mm_hi = state[22:19];
    wire [3:0] mm_lo = state[18:15];
    wire [3:0] ss_hi = state[14:11];
    wire [3:0] ss_lo = state[10:7];

    // Next state computation (combinational)
    wire [31:0] next_state;
    assign next_state = 
        reset ? 32'h0_1_2_0_0_0_0 :  // Reset to 12:00:00 AM
        ~ena ? state :                 // Hold when not enabled
        {
            // PM toggle logic (toggles when going from 11:59:59 to 12:00:00)
            (state[30:23] == 8'h11 && state[22:7] == 16'h5959) ? ~pm_reg : pm_reg,
            
            // Hour counter logic
            (state[22:7] == 16'h5959) ?  // Only update hours at 59:59
                (state[30:23] == 8'h12) ? 8'h01 :  // 12 -> 1
                (state[26:23] == 4'd9) ? {hh_hi + 1, 4'd0} : {hh_hi, hh_lo + 1}
            : state[30:23],
            
            // Minute counter logic
            (state[14:7] == 8'h59) ?  // Only update minutes at 59 seconds
                (state[22:19] == 4'd5 && state[18:15] == 4'd9) ? 8'h00 :  // 59 -> 00
                (state[18:15] == 4'd9) ? {mm_hi + 1, 4'd0} : {mm_hi, mm_lo + 1}
            : state[22:15],
            
            // Second counter logic
            (state[10:7] == 4'd9) ? 
                (state[14:11] == 4'd5) ? 8'h00 : {ss_hi + 1, 4'd0}
            : {ss_hi, ss_lo + 1}
        };

    // State update
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output assignments
    assign pm = pm_reg;
    assign hh = {hh_hi, hh_lo};
    assign mm = {mm_hi, mm_lo};
    assign ss = {ss_hi, ss_lo};

endmodule