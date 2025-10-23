module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt_4;  // Counter for 4 source clock cycles
reg [2:0] cnt_3;  // Counter for 3 source clock cycles
reg clk_div_4;    // Divided clock for 4 source clock cycles
reg clk_div_3;    // Divided clock for 3 source clock cycles
reg clk_div_delayed;  // Delayed version of divided clock
reg clk_div_advanced;  // Advanced version of divided clock

// Sequential logic for counters
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt_4 <= 3'b000;
        cnt_3 <= 3'b000;
        clk_div_4 <= 1'b0;
        clk_div_3 <= 1'b0;
    end else begin
        // Counter for 4 source clock cycles
        if (cnt_4 == 4'd3) begin
            cnt_4 <= 3'b000;
            clk_div_4 <= 1'b1;
        end else begin
            cnt_4 <= cnt_4 + 1'b1;
            clk_div_4 <= 1'b0;
        end
        
        // Counter for 3 source clock cycles
        if (cnt_3 == 4'd2) begin
            cnt_3 <= 3'b000;
            clk_div_3 <= 1'b1;
        end else begin
            cnt_3 <= cnt_3 + 1'b1;
            clk_div_3 <= 1'b0;
        end
    end
end

// Phase-shifting mechanism
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_delayed <= 1'b0;
        clk_div_advanced <= 1'b0;
    end else begin
        // Delayed version of divided clock
        if (clk_div_4 || clk_div_3) begin
            clk_div_delayed <= 1'b1;
        end else begin
            clk_div_delayed <= 1'b0;
        end
        
        // Advanced version of divided clock
        if (cnt_4 == 3'b001 || cnt_3 == 3'b001) begin
            clk_div_advanced <= 1'b1;
        end else begin
            clk_div_advanced <= 1'b0;
        end
    end
end

// Combinational logic for final output
assign clk_div = clk_div_delayed || clk_div_advanced;

endmodule