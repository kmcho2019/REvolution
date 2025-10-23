module freq_divbyfrac(
    input  clk,     // Input clock signal
    input  rst_n,   // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division (3.5x)
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division
parameter DIV_CLK_HIGH = 4;  // Clock cycles for the high period
parameter DIV_CLK_LOW = 3;   // Clock cycles for the low period

reg [2:0] cnt;  // Counter to track the clock cycles
reg div_clk_int1;  // Intermediate divided clock signal 1
reg div_clk_int2;  // Intermediate divided clock signal 2
reg div_clk_int1_phase_shifted;  // Phase-shifted version of div_clk_int1
reg div_clk_int2_phase_shifted;  // Phase-shifted version of div_clk_int2

// Counter to generate the intermediate divided clock signals
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        div_clk_int1 <= 1'b0;
        div_clk_int2 <= 1'b0;
        div_clk_int1_phase_shifted <= 1'b0;
        div_clk_int2_phase_shifted <= 1'b0;
    end else begin
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
            div_clk_int1 <= 1'b1;
            div_clk_int2 <= 1'b1;
        end else if (cnt < DIV_CLK_HIGH) begin
            div_clk_int1 <= 1'b1;
            div_clk_int2 <= 1'b0;
        end else begin
            div_clk_int1 <= 1'b0;
            div_clk_int2 <= 1'b1;
        end
        cnt <= cnt + 1'b1;
    end
end

// Phase-shifting mechanism for the intermediate clocks
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        div_clk_int1_phase_shifted <= 1'b0;
        div_clk_int2_phase_shifted <= 1'b0;
    end else begin
        div_clk_int1_phase_shifted <= div_clk_int1;
        div_clk_int2_phase_shifted <= div_clk_int2;
    end
end

// Logical OR operation to produce the final fractional divided clock output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end else begin
        // Apply the phase shift to the intermediate clocks
        reg div_clk_int1_delayed;
        reg div_clk_int1_advanced;
        reg div_clk_int2_delayed;
        reg div_clk_int2_advanced;
        always @(posedge clk) begin
            div_clk_int1_delayed <= div_clk_int1;
            div_clk_int1_advanced <= div_clk_int1;
            div_clk_int2_delayed <= div_clk_int2;
            div_clk_int2_advanced <= div_clk_int2;
        end
        // For simulation only; not synthesisable.
        //assign div_clk_int1_delayed = div_clk_int1;
        //assign div_clk_int1_advanced = div_clk_int1;
        //assign div_clk_int2_delayed = div_clk_int2;
        //assign div_clk_int2_advanced = div_clk_int2;
        clk_div <= div_clk_int1_phase_shifted | div_clk_int2_phase_shifted;
    end
end

endmodule