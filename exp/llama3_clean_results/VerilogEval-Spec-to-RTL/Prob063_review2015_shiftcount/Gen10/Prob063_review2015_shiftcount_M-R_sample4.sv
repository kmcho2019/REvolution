module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg = 4'b0000; // Initialize q_reg to 0

// Combinational logic to define the next state of q_reg
wire [3:0] q_next;
assign q_next = (shift_ena)? {data, q_reg[3:1]} : ((count_ena && q_reg > 0)? q_reg - 1 : q_reg);

// Sequential logic to update q_reg
always @(posedge clk) begin
    q_reg <= q_next;
end

assign q = q_reg;

endmodule