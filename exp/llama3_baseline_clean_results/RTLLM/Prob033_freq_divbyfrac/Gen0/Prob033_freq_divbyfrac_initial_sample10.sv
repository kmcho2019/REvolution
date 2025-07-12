module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

parameter MUL2_DIV_CLK = 7;

reg [2:0] cnt; // Counter for 7 clock cycles (3-bit)
reg phase_clk1, phase_clk2; // Phase-shifted clocks
reg div_clk_int1, div_clk_int2; // Intermediate divided clocks

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 3'b000; // Initialize counter
        phase_clk1 <= 1'b0;
        phase_clk2 <= 1'b0;
        div_clk_int1 <= 1'b0;
        div_clk_int2 <= 1'b0;
    end else begin
        // Count clock cycles and generate intermediate divided clocks
        if (cnt == 3'b110) begin // 6th cycle, reset counter
            cnt <= 3'b000;
            div_clk_int1 <= 1'b1;
            div_clk_int2 <= 1'b0;
        end else if (cnt == 3'b101) begin // 5th cycle
            cnt <= cnt + 1'b1;
            div_clk_int1 <= 1'b1;
            div_clk_int2 <= 1'b0;
        end else if (cnt == 3'b100) begin // 4th cycle
            cnt <= cnt + 1'b1;
            div_clk_int1 <= 1'b1;
            div_clk_int2 <= 1'b0;
        end else if (cnt == 3'b011) begin // 3rd cycle
            cnt <= cnt + 1'b1;
            div_clk_int1 <= 1'b0;
            div_clk_int2 <= 1'b1;
        end else if (cnt == 3'b010) begin // 2nd cycle
            cnt <= cnt + 1'b1;
            div_clk_int1 <= 1'b0;
            div_clk_int2 <= 1'b1;
        end else if (cnt == 3'b001) begin // 1st cycle
            cnt <= cnt + 1'b1;
            div_clk_int1 <= 1'b0;
            div_clk_int2 <= 1'b1;
        end else begin
            cnt <= cnt + 1'b1;
            div_clk_int1 <= 1'b0;
            div_clk_int2 <= 1'b0;
        end
    end
end

// Phase-shifting mechanism
always @(posedge clk) begin
    phase_clk1 <= ~div_clk_int1;
    phase_clk2 <= div_clk_int2;
end

// Logical OR operation to produce the final fractional divided clock output
always @(posedge clk) begin
    clk_div <= div_clk_int1 | phase_clk2;
end

endmodule