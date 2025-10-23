module TopModule (
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q_reg;
wire [2:0] q_next;

// Combinational next state logic
assign q_next = a ? 3'd4 : 
                (q_reg == 3'd6) ? 3'd0 : q_reg + 3'd1;

// Sequential state update
always @(posedge clk) begin
    q_reg <= q_next;
end

// Output assignment
assign q = q_reg;

endmodule