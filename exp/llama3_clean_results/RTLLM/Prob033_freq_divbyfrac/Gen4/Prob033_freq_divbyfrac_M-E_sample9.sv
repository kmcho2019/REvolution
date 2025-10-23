module freq_divbyfrac(
    input clk,      // Input clock signal
    input rst_n,     // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameter for the multiplier (3.5x division)
localparam MUL2_DIV_CLK = 7;

// Signals for clock generators
reg clk_ref;  // Reference divided clock
reg clk_delayed;  // Delayed version of clk_ref
reg clk_advanced;  // Advanced version of clk_ref

// Clock cycle counter and phase controller
reg [2:0] counter;
reg [2:0] next_counter;

// Control signals for clock generators
reg gen_delayed;  // Enable signal for delayed clock generator
reg gen_advanced;  // Enable signal for advanced clock generator

// Weighted combiner and duty cycle adjuster
reg weighted_sum;  // Output of weighted combiner

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset all signals
        counter <= 3'd0;
        clk_ref <= 1'b0;
        clk_delayed <= 1'b0;
        clk_advanced <= 1'b0;
        gen_delayed <= 1'b0;
        gen_advanced <= 1'b0;
        weighted_sum <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        case (counter)
            3'd0: begin
                // Generate reference divided clock
                clk_ref <= ~clk_ref;
                // Enable delayed clock generator
                gen_delayed <= 1'b1;
                next_counter <= 3'd1;
            end
            3'd1, 3'd2, 3'd3: begin
                next_counter <= counter + 1;
            end
            3'd4: begin
                // Disable delayed clock generator
                gen_delayed <= 1'b0;
                // Enable advanced clock generator
                gen_advanced <= 1'b1;
                next_counter <= 3'd5;
            end
            3'd5, 3'd6: begin
                next_counter <= counter + 1;
            end
            3'd7: begin
                // Disable advanced clock generator
                gen_advanced <= 1'b0;
                next_counter <= 3'd0;
            end
        endcase
        counter <= next_counter;

        // Phase-shifting logic
        if (gen_delayed) begin
            clk_delayed <= ~clk_delayed;
        end
        if (gen_advanced) begin
            clk_advanced <= ~clk_advanced;
        end

        // Weighted combiner and duty cycle adjuster
        weighted_sum <= (clk_delayed & ~clk_ref) | (clk_advanced & clk_ref);

        // Assign output
        clk_div <= weighted_sum;
    end
end

endmodule