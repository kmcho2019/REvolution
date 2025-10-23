module TopModule(
    input clk,
    input d,
    output reg q
);

reg prev_clk;  // Previous clock value
reg q_reg;     // Output register

// Detect clock edges and update output
always @(posedge clk) begin
    prev_clk <= clk;
    q_reg <= d;
end

// Use assign to select output based on clock edge
assign q = (clk == prev_clk) ? q_reg : d;

initial begin
    prev_clk = 0;
    q_reg = 0;
end

endmodule