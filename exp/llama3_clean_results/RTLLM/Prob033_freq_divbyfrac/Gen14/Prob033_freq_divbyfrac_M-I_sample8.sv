module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for frequency division
parameter MUL2_DIV_CLK = 7;  // Clock cycles for 3.5x division

// Internal signals
reg [2:0] counter;  // Counter for clock cycles
reg [1:0] state;  // State machine for phase-shifting
reg clk_div_int;  // Internal clock signal
reg clk_div_int_delayed;  // Delayed internal clock signal
reg clk_div_int_advanced;  // Advanced internal clock signal

// State machine
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'd0;
        state <= 2'd0;
        clk_div_int <= 1'b0;
        clk_div_int_delayed <= 1'b0;
        clk_div_int_advanced <= 1'b0;
    end else begin
        // Count clock cycles
        counter <= counter + 1'd1;
        
        // Generate intermediate divided clock signal
        if (counter == 3'd4) begin
            clk_div_int <= 1'b1;
        end else if (counter == 3'd7) begin
            clk_div_int <= 1'b0;
        end
        
        // Phase-shift divided clock signal
        case (state)
            2'd0: begin
                if (counter == 3'd4) begin
                    state <= 2'd1;
                    clk_div_int_delayed <= 1'b1;
                end
            end
            2'd1: begin
                if (counter == 3'd7) begin
                    state <= 2'd2;
                    clk_div_int_delayed <= 1'b0;
                end
            end
            2'd2: begin
                if (counter == 3'd4) begin
                    state <= 2'd0;
                    clk_div_int_advanced <= 1'b1;
                end
            end
            default: begin
                state <= 2'd0;
            end
        endcase
        
        // Generate final fractional divided clock output
        clk_div_int_delayed <= clk_div_int_delayed;
        clk_div_int_advanced <= clk_div_int_advanced;
    end
end

// Assign the final output
assign clk_div = clk_div_int_delayed | clk_div_int_advanced;

endmodule