module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg;
wire [3:0] next_q;

// Next state logic
assign next_q = shift_ena ? {q_reg[2:0], data} :  // Shift operation
               count_ena ? q_reg - 1'b1 :         // Count operation
               q_reg;                              // Hold state

// Register update
always @(posedge clk) begin
    q_reg <= next_q;
end

assign q = q_reg;

endmodule