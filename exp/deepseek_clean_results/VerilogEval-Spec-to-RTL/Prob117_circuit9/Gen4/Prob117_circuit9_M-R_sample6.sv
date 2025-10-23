module TopModule (
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q_reg = 3'b100;
wire [2:0] next_q;

// Combinational next-state logic
assign next_q = a ? q_reg : 
               (q_reg == 3'b110) ? 3'b000 : q_reg + 1;

// Sequential storage
always @(posedge clk) begin
    q_reg <= next_q;
end

// Output assignment
assign q = q_reg;

endmodule