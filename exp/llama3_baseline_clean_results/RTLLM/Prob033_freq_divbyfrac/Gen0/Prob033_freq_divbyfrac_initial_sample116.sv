module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for 3.5x frequency division
parameter MUL2_DIV_CLK = 7; // Total clock cycles for division
parameter DIV_CYCLES_1 = 4; // First uneven clock period
parameter DIV_CYCLES_2 = 3; // Second uneven clock period

reg [2:0] counter; // Counter for clock cycle tracking
reg clk_int1, clk_int2; // Intermediate divided clock signals
reg clk_phase1, clk_phase2; // Phase-shifted clock signals

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000;
        clk_int1 <= 1'b0;
        clk_int2 <= 1'b0;
        clk_phase1 <= 1'b0;
        clk_phase2 <= 1'b0;
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000;
            if (clk_int1) begin
                clk_int1 <= 1'b0;
            end else if (counter == MUL2_DIV_CLK - 2) begin
                clk_int1 <= 1'b1;
            end
            if (clk_int2) begin
                clk_int2 <= 1'b0;
            end else if (counter == MUL2_DIV_CLK - 3) begin
                clk_int2 <= 1'b1;
            end
        end else begin
            counter <= counter + 1'b1;
        end
    end
end

// Phase-shifting and multiplexing
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_phase1 <= 1'b0;
        clk_phase2 <= 1'b0;
    end else begin
        if (counter < DIV_CYCLES_1) begin
            clk_phase1 <= clk_int1;
        end else begin
            clk_phase1 <= ~clk_int1;
        end
        if (counter < DIV_CYCLES_2) begin
            clk_phase2 <= clk_int2;
        end else begin
            clk_phase2 <= ~clk_int2;
        end
    end
end

// Final fractional divided clock output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end else begin
        clk_div <= clk_phase1 | clk_phase2;
    end
end

endmodule