module TopModule (
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q_reg;
wire [2:0] next_q;

// Initialize register to 4
initial begin
    q_reg = 3'd4;
end

// Next state logic using continuous assignment
assign next_q = a ? 3'd4 : 
               (q_reg == 3'd6) ? 3'd0 : q_reg + 1;

// Register update
always @(posedge clk) begin
    q_reg <= next_q;
end

// Output assignment
assign q = q_reg;

endmodule