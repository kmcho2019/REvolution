module TopModule (
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q_reg = 3'b100;  // Initialize to 4
wire [2:0] next_q;

// Combinational logic for next state
assign next_q = a ? q_reg : 
               (q_reg == 3'b110) ? 3'b000 : 
               q_reg + 1;

// Sequential logic (register update)
always @(posedge clk) begin
    q_reg <= next_q;
end

assign q = q_reg;

endmodule