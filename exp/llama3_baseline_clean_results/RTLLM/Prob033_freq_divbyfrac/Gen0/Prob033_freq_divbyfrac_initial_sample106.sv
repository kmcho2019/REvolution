module freq_divbyfrac(
    input clk,      // Input clock signal
    input rst_n,    // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

parameter MUL2_DIV_CLK = 7;  // 3.5x division, counter value

reg [2:0] counter;  // Counter to track clock cycles
reg clk_int1, clk_int2;  // Intermediate divided clock signals
reg clk_int1_delayed, clk_int2_advanced;  // Phase-shifted intermediate clocks

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000;
        clk_int1 <= 1'b0;
        clk_int2 <= 1'b0;
    end
    else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000;
        end
        else begin
            counter <= counter + 1'b1;
        end

        // Generate intermediate divided clock signals
        if (counter == 3'b100) begin  // 4 source clock cycles
            clk_int1 <= 1'b1;
        end
        else if (counter == 3'b011) begin  // 3 source clock cycles
            clk_int1 <= 1'b0;
        end

        if (counter == 3'b011) begin  // 3 source clock cycles
            clk_int2 <= 1'b1;
        end
        else if (counter == 3'b100) begin  // 4 source clock cycles
            clk_int2 <= 1'b0;
        end
    end
end

// Half-period delay and advance circuit
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_int1_delayed <= 1'b0;
        clk_int2_advanced <= 1'b0;
    end
    else begin
        clk_int1_delayed <= clk_int1;
        clk_int2_advanced <= clk_int2;
    end
end

// Generate phase-shifted intermediate clocks
reg prev_clk_int1, prev_clk_int2;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        prev_clk_int1 <= 1'b0;
        prev_clk_int2 <= 1'b0;
    end
    else begin
        prev_clk_int1 <= clk_int1;
        prev_clk_int2 <= clk_int2;
    end
end

assign clk_int1_delayed = prev_clk_int1;
assign clk_int2_advanced = clk_int2;

// Logically OR the phase-shifted intermediate clocks
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end
    else begin
        clk_div <= clk_int1_delayed | clk_int2_advanced;
    end
end

endmodule