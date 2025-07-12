module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

initial begin
    q <= 3'd4; // Initialize q at the start of simulation for clarity and robustness
end

always @(posedge clk) 
    q <= a? 3'd4 : (q == 3'd6)? 3'd0 : q + 1; // Use ternary operator for conciseness and efficiency

endmodule