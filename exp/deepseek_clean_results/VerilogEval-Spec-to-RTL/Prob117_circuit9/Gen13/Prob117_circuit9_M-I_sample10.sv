module TopModule (
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q_reg;
wire [2:0] q_next;
wire enable;

// Enable logic - only update when needed
assign enable = (a || (q_reg != 3'd4)) ? 1'b1 : 1'b0;

// Optimized next state logic
assign q_next = a ? 3'd4 : 
                {q_reg[2:1], ~q_reg[0]} + {2'b0, q_reg[1] & q_reg[0]};

// Sequential state update with enable
always @(posedge clk) begin
    if (enable) begin
        q_reg <= q_next;
    end
end

// Output assignment
assign q = q_reg;

endmodule