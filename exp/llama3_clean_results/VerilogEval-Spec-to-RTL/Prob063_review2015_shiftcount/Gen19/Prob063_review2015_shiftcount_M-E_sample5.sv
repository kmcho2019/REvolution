module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg = 4'b0;

wire [3:0] shifted_data;
assign shifted_data = {q_reg[2:0], data};

wire [3:0] decremented_data;
assign decremented_data = q_reg - 1'b1;

wire [3:0] next_q;
assign next_q = (shift_ena) ? shifted_data : (count_ena) ? decremented_data : q_reg;

always @(posedge clk) begin
    q_reg <= next_q;
end

assign q = q_reg;

endmodule