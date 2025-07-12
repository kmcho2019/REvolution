module freq_div(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

// DCO parameters
parameter DCO_INIT = 10'd500;  // Initial DCO value
parameter DCO_MIN = 10'd100;   // Minimum DCO value
parameter DCO_MAX = 10'd1000;  // Maximum DCO value

// DCO control word
reg [9:0] dco_ctrl;

// Phase detector output
reg phase_det_out;

// Loop filter parameters
parameter LPF_POLES = 2;  // Number of loop filter poles
parameter LPF_ZEROS = 1;  // Number of loop filter zeros
parameter LPF_GAIN = 10'd100;  // Loop filter gain

// Loop filter state variables
reg [LPF_POLES-1:0] lpf_state;

// DCO output frequency
reg [9:0] dco_freq;

// Divider parameters
parameter DIV_50 = 2;  // Divider value for 50MHz output
parameter DIV_10 = 10;  // Divider value for 10MHz output
parameter DIV_1 = 100;  // Divider value for 1MHz output

// Divider state variables
reg [9:0] div_50_cnt;
reg [9:0] div_10_cnt;
reg [9:0] div_1_cnt;

always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        // Reset DCO control word and phase detector output
        dco_ctrl <= DCO_INIT;
        phase_det_out <= 0;
        
        // Reset loop filter state variables
        lpf_state <= 0;
        
        // Reset DCO output frequency
        dco_freq <= 0;
        
        // Reset divider state variables
        div_50_cnt <= 0;
        div_10_cnt <= 0;
        div_1_cnt <= 0;
        
        // Reset output clocks
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
    end else begin
        // Update phase detector output
        phase_det_out <= (dco_freq > DCO_INIT) ? 1 : 0;
        
        // Update loop filter state variables
        lpf_state <= (lpf_state + phase_det_out) % (2**LPF_POLES);
        
        // Update DCO control word
        dco_ctrl <= (dco_ctrl + (LPF_GAIN * lpf_state)) % (2**10);
        
        // Update DCO output frequency
        dco_freq <= (dco_ctrl * (2**10)) / (2**10);
        
        // Update divider state variables
        div_50_cnt <= (div_50_cnt + 1) % DIV_50;
        div_10_cnt <= (div_10_cnt + 1) % DIV_10;
        div_1_cnt <= (div_1_cnt + 1) % DIV_1;
        
        // Update output clocks
        CLK_50 <= (div_50_cnt == 0) ? ~CLK_50 : CLK_50;
        CLK_10 <= (div_10_cnt == 0) ? ~CLK_10 : CLK_10;
        CLK_1 <= (div_1_cnt == 0) ? ~CLK_1 : CLK_1;
    end
end

endmodule