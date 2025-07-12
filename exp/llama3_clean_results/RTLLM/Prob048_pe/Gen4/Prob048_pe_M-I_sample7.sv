module pe (
    input clk, 
    input rst, 
    input [31:0] a, 
    input [31:0] b, 
    output reg [31:0] c
);

// Internal signal for clock gating
reg clk_enable;

// Always block for clock gating
always @(posedge clk or posedge rst) begin
    if (rst) 
        clk_enable <= 0;
    else if (a!= 0 || b!= 0) // Enable clock if either a or b is not zero
        clk_enable <= 1;
    else 
        clk_enable <= 0;
end

// Always block for accumulation, using the clock enable signal
always @(posedge clk or posedge rst) begin
    if (rst) 
        c <= 0;
    else if (clk_enable) 
        c <= c + (a * b);
end

endmodule