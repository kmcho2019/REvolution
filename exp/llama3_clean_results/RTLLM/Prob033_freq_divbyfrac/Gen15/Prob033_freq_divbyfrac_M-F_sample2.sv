module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Counter for 3.5x division
reg [2:0] cnt_delayed;  // Delayed counter for phase-shifting
reg clk_div_int;  // Intermediate divided clock signal
reg clk_div_delayed;  // Delayed version of divided clock signal
reg clk_div_advanced;  // Advanced version of divided clock signal

// Sequential logic for counters
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        cnt_delayed <= 3'b000;
        clk_div_int <= 1'b0;
        clk_div_delayed <= 1'b0;
        clk_div_advanced <= 1'b0;
    end else begin
        // Counter for 4 out of 7 cycles
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1'b1;
        end
        
        // Delayed counter for phase-shifting
        cnt_delayed <= cnt;
        
        // Generate intermediate divided clock signal
        if (cnt == 3'b000 || cnt == 3'b001 || cnt == 3'b010 || cnt == 3'b011) begin
            clk_div_int <= 1'b1;
        end else begin
            clk_div_int <= 1'b0;
        end
        
        // Generate delayed version of divided clock signal
        clk_div_delayed <= clk_div_int;
        
        // Generate advanced version of divided clock signal
        if (cnt == 3'b100 || cnt == 3'b101 || cnt == 3'b110 || cnt == 3'b111) begin
            clk_div_advanced <= 1'b1;
        end else begin
            clk_div_advanced <= 1'b0;
        end
    end
end

// Combinational logic for final divided clock output
assign clk_div = clk_div_int || clk_div_delayed || clk_div_advanced;

endmodule