module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for frequency division
parameter MUL2_DIV_CLK = 7;  // Clock cycles for 3.5x division

// Internal signals
reg [2:0] counter;  // Counter for clock cycles
reg clk_div_int;  // Internal clock signal
reg clk_div_int_delayed;  // Delayed internal clock signal

// State machine
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'd0;
        clk_div_int <= 1'b0;
        clk_div_int_delayed <= 1'b0;
    end else begin
        // Count clock cycles
        counter <= counter + 1'd1;
        
        // Generate intermediate divided clock signal
        if (counter == 3'd4) begin
            clk_div_int <= 1'b1;
        end else if (counter == 3'd7) begin
            clk_div_int <= 1'b0;
            counter <= 3'd0;  // Reset counter
        end
        
        // Phase-shift divided clock signal
        if (counter == 3'd2) begin
            clk_div_int_delayed <= 1'b1;
        end else if (counter == 3'd5) begin
            clk_div_int_delayed <= 1'b0;
        end
    end
end

// Assign the final output
assign clk_div = clk_div_int | clk_div_int_delayed;

endmodule