module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,      // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for frequency division
parameter MUL2_DIV_CLK = 7; // For 3.5x division

// Internal signals
reg [2:0] cnt; // Counter to track clock cycles
reg clk_div_int1; // Intermediate divided clock 1
reg clk_div_int2; // Intermediate divided clock 2

// Counter to generate uneven clock periods
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'd0;
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
    end else begin
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'd0;
        end else begin
            cnt <= cnt + 1;
        end
        
        // Generate uneven clock periods
        if (cnt == 3'd3) begin
            clk_div_int1 <= ~clk_div_int1;
        end
        
        if (cnt == 3'd6) begin
            clk_div_int2 <= ~clk_div_int2;
        end
    end
end

// Phase-shift the divided clocks
reg clk_div_int1_ph;
reg clk_div_int2_ph;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_int1_ph <= 1'b0;
        clk_div_int2_ph <= 1'b0;
    end else begin
        // Phase-shift divided clock 1 by half a clock period (delayed)
        if (cnt == 3'd0) begin
            clk_div_int1_ph <= clk_div_int1;
        end else begin
            clk_div_int1_ph <= clk_div_int1_ph;
        end
        
        // Phase-shift divided clock 2 by half a clock period (advanced)
        if (cnt == 3'd3) begin
            clk_div_int2_ph <= ~clk_div_int2;
        end else begin
            clk_div_int2_ph <= clk_div_int2_ph;
        end
    end
end

// Logically OR the two intermediate clocks
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end else begin
        clk_div <= clk_div_int1_ph | clk_div_int2_ph;
    end
end

endmodule