module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam integer CNT_MAX = 7;  // Counting from 0 to 6
    
    reg [2:0] cnt;

    // Counter increments from 0 to 6 repeatedly on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == CNT_MAX - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // Generate the positive edge divided clock:
    // High for counts 0,1,2,3 (4 cycles), low for 4,5,6 (3 cycles)
    wire clk_div_pos = (cnt < 4);

    // Generate the half-cycle phase shifted clock by offsetting the count by 1 modulo 7.
    // This simulates a phase shift by half clock cycle.
    wire [2:0] cnt_neg = (cnt == 0) ? (CNT_MAX - 1) : (cnt - 1);

    // clk_div_neg high for counts 0,1,2,3 (same pattern shifted by one count)
    wire clk_div_neg = (cnt_neg < 4);

    // Combine both clocks to form the fractional clock output
    assign clk_div = clk_div_pos | clk_div_neg;

endmodule