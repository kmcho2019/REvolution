module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

// Internal signals
wire [3:0] alu_in;
wire [3:0] alu_out;
wire alu_enable;

// Operation selection and ALU input mux
assign alu_enable = shift_ena | count_ena;
assign alu_in = shift_ena ? {q[2:0], data} : q;

// ALU implementation (shift or decrement)
assign alu_out = shift_ena ? alu_in : (alu_in - 1'b1);

// Registered output
always @(posedge clk) begin
    q <= alu_enable ? alu_out : q;
end

endmodule