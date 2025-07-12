module TopModule (
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q_reg;
wire [2:0] next_q;

// Combinational next state logic
assign next_q = a ? 3'd4 : 
                (q_reg == 3'd6) ? 3'd0 : 
                q_reg + 1;

// Sequential element
always @(posedge clk) begin
    q_reg <= next_q;
end

assign q = q_reg;

endmodule