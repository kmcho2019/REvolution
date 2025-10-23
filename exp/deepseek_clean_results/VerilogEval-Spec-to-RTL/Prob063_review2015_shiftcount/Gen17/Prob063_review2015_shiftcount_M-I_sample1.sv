module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg;
wire [3:0] next_q;
wire any_ena = shift_ena | count_ena;
wire [3:0] decremented = q_reg - 1'b1;

// Clock gating logic
wire gated_clk;
assign gated_clk = clk & any_ena;

// Next state logic with priority encoding
assign next_q = shift_ena ? {q_reg[2:0], data} :  // Shift has priority
               count_ena ? decremented :          // Then count
               q_reg;                             // Hold state

// Register update with clock gating
always @(posedge gated_clk) begin
    q_reg <= next_q;
end

assign q = q_reg;

endmodule