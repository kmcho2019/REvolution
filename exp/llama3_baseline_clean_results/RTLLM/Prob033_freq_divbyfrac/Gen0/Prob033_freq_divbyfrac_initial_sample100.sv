module freq_divbyfrac (
    input clk,         // Input clock signal
    input rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Counter to cycle through 7 clock cycles
reg [2:0] cnt;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
    end else if (cnt == 3'b110) begin
        cnt <= 3'b000;
    end else begin
        cnt <= cnt + 1;
    end
end

// Generate uneven clock periods (4 and 3 source clock cycles)
reg clk_div_int1, clk_div_int2;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
    end else begin
        if (cnt == 3'b001) begin
            clk_div_int1 <= 1'b1;
        end else if (cnt == 3'b100) begin
            clk_div_int1 <= 1'b0;
        end
        
        if (cnt == 3'b101) begin
            clk_div_int2 <= 1'b1;
        end else if (cnt == 3'b011) begin
            clk_div_int2 <= 1'b0;
        end
    end
end

// Phase-shifted versions of the divided clocks
reg clk_div_int1_delayed, clk_div_int1_advanced, clk_div_int2_delayed, clk_div_int2_advanced;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_int1_delayed <= 1'b0;
        clk_div_int1_advanced <= 1'b0;
        clk_div_int2_delayed <= 1'b0;
        clk_div_int2_advanced <= 1'b0;
    end else begin
        if (cnt == 3'b001) begin
            clk_div_int1_delayed <= 1'b0;
            clk_div_int1_advanced <= 1'b1;
        end else if (cnt == 3'b100) begin
            clk_div_int1_delayed <= 1'b1;
            clk_div_int1_advanced <= 1'b0;
        end
        
        if (cnt == 3'b101) begin
            clk_div_int2_delayed <= 1'b0;
            clk_div_int2_advanced <= 1'b1;
        end else if (cnt == 3'b011) begin
            clk_div_int2_delayed <= 1'b1;
            clk_div_int2_advanced <= 1'b0;
        end
    end
end

// Final fractional divided clock output (logical OR of phase-shifted clocks)
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end else begin
        clk_div <= (clk_div_int1 | clk_div_int1_delayed | clk_div_int1_advanced) | (clk_div_int2 | clk_div_int2_delayed | clk_div_int2_advanced);
    end
end

endmodule