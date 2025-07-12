module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Counter for 3.5x division
reg clk_div_int;  // Intermediate divided clock

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
    end else begin
        cnt <= cnt + 1'b1;
    end
end

// Intermediate divided clock generation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_int <= 1'b0;
    end else begin
        if (cnt == 3'b100 || cnt == 3'b011) begin
            clk_div_int <= ~clk_div_int;
        end
    end
end

// Phase-shifting and final divided clock output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end else begin
        if (cnt == 3'b101 || cnt == 3'b010) begin
            clk_div <= ~clk_div_int;
        end else begin
            clk_div <= clk_div_int;
        end
    end
end

endmodule