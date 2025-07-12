module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg;
wire [3:0] next_q;

// Calculate the next state of q_reg based on the current state and inputs
assign next_q = (shift_ena) ? {q_reg[2:0], data} : (count_ena) ? (q_reg == 4'd0) ? 4'd0 : q_reg - 1 : q_reg;

// Always block to handle the positive edge of the clock
always @(posedge clk) begin
    // Update q_reg with the calculated next state
    q_reg <= next_q;
end

// Continuous assignment to output the current state of the internal register
assign q = q_reg;

endmodule