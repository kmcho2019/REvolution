module freq_divbyfrac(
    input clk,      // Input clock signal
    input rst_n,     // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameter for the multiplier (3.5x division)
localparam MUL2_DIV_CLK = 7;

// Signals for uneven clock periods
reg [2:0] counter;
reg clk_div_4;
reg clk_div_3;
reg clk_div_4_ff;
reg clk_div_3_ff;
reg clk_div_4_delayed;
reg clk_div_3_advanced;

// Look-up table (LUT) to store pre-computed phase-shifted clock values
reg [1:0] lut_values[7:0];

// Initialize the LUT values
initial begin
    for (int i = 0; i < MUL2_DIV_CLK; i++) begin
        if (i < 4) begin
            lut_values[i] = 2'b01; // 4 clock cycles
        end else begin
            lut_values[i] = 2'b10; // 3 clock cycles
        end
    end
end

// State machine for frequency divider
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'd0;
        clk_div_4 <= 1'b0;
        clk_div_3 <= 1'b0;
        clk_div_4_ff <= 1'b0;
        clk_div_3_ff <= 1'b0;
        clk_div_4_delayed <= 1'b0;
        clk_div_3_advanced <= 1'b0;
    end else begin
        counter <= counter + 1;

        if (counter < 3'd4) begin
            clk_div_4 <= 1'b1;
            clk_div_3 <= 1'b0;
        end else if (counter >= 3'd4 && counter < 3'd7) begin
            clk_div_4 <= 1'b0;
            clk_div_3 <= 1'b1;
        end else if (counter == 3'd7) begin
            clk_div_4 <= 1'b0;
            clk_div_3 <= 1'b0;
            counter <= 3'd0;
        end

        // Phase-shift the uneven clock periods using the LUT
        case (counter)
            3'd0: begin
                clk_div_4_ff <= lut_values[0][0];
                clk_div_3_ff <= lut_values[0][1];
            end
            3'd1: begin
                clk_div_4_ff <= lut_values[1][0];
                clk_div_3_ff <= lut_values[1][1];
            end
            3'd2: begin
                clk_div_4_ff <= lut_values[2][0];
                clk_div_3_ff <= lut_values[2][1];
            end
            3'd3: begin
                clk_div_4_ff <= lut_values[3][0];
                clk_div_3_ff <= lut_values[3][1];
            end
            3'd4: begin
                clk_div_4_ff <= lut_values[4][0];
                clk_div_3_ff <= lut_values[4][1];
            end
            3'd5: begin
                clk_div_4_ff <= lut_values[5][0];
                clk_div_3_ff <= lut_values[5][1];
            end
            3'd6: begin
                clk_div_4_ff <= lut_values[6][0];
                clk_div_3_ff <= lut_values[6][1];
            end
            default: begin
                clk_div_4_ff <= 1'b0;
                clk_div_3_ff <= 1'b0;
            end
        endcase

        // Delay and advance the clock signals by half a clock period
        if (counter < 3'd4) begin
            clk_div_4_delayed <= clk_div_4;
            clk_div_3_advanced <= ~clk_div_3;
        end else begin
            clk_div_4_delayed <= ~clk_div_4;
            clk_div_3_advanced <= clk_div_3;
        end
    end
end

// Generate the final divided clock output
assign clk_div = (clk_div_4_ff | clk_div_3_ff);

endmodule