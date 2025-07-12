module TopModule(
    input clk,
    input d,
    output reg q
);

reg prev_clk; // Previous clock value
reg q_reg; // Output register

// Update previous clock value
always @(posedge clk or negedge clk)
    prev_clk <= clk;

// Dual-edge triggered flip-flop
always @(posedge clk or negedge clk)
    if (prev_clk != clk) // Clock edge detection
        q_reg <= d;
    else
        q_reg <= q_reg;

assign q = q_reg;

endmodule