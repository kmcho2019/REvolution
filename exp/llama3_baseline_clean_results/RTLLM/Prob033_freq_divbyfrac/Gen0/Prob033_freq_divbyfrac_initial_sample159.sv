module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for 3.5x division
localparam MUL2_DIV_CLK = 7; // Modulus for counter
localparam PHASE_DELAY = 4;  // Number of clock cycles for one phase
localparam PHASE_ADVANCE = 3; // Number of clock cycles for the other phase

// Internal signals
reg [2:0] counter; // Counter to track clock cycles
reg clk_int1, clk_int2; // Intermediate clock signals
reg clk_int1_ph, clk_int2_ph; // Phase-shifted intermediate clock signals

// Counter to track clock cycles
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000;
        clk_int1 <= 1'b0;
        clk_int2 <= 1'b0;
    end else if (counter == MUL2_DIV_CLK - 1) begin
        counter <= 3'b000;
        if (clk_int1) begin
            clk_int1 <= 1'b0;
        end else if (counter == MUL2_DIV_CLK - 1) begin
            clk_int1 <= 1'b1;
        end
        if (clk_int2) begin
            clk_int2 <= 1'b0;
        end else if (counter == MUL2_DIV_CLK - 2) begin
            clk_int2 <= 1'b1;
        end
    end else begin
        counter <= counter + 1;
        if (counter == PHASE_DELAY - 1) begin
            clk_int1 <= 1'b1;
        end else if (counter == MUL2_DIV_CLK - 1) begin
            clk_int1 <= 1'b0;
        end
        if (counter == PHASE_ADVANCE - 1) begin
            clk_int2 <= 1'b1;
        end else if (counter == MUL2_DIV_CLK - 2) begin
            clk_int2 <= 1'b0;
        end
    end
end

// Phase-shifting of intermediate clocks
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_int1_ph <= 1'b0;
        clk_int2_ph <= 1'b0;
    end else begin
        clk_int1_ph <= clk_int1;
        clk_int2_ph <= clk_int2;
    end
end

// Double-edge clocking to achieve half-integer division
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end else begin
        if (clk_int1_ph || clk_int2_ph) begin
            clk_div <= 1'b1;
        end else begin
            clk_div <= 1'b0;
        end
    end
end

endmodule