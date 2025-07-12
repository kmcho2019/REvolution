module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg;
wire [3:0] next_q;

// Compute next_q combinationally using a conditional operator
assign next_q = shift_ena ? {data, q_reg[3:1]} :
                count_ena ? (q_reg - 4'b0001) :
                q_reg;

// Synchronous reset to zero on start (optional, remove if undesired)
initial begin
    q_reg = 4'b0000;
end

always @(posedge clk) begin
    q_reg <= next_q;
end

assign q = q_reg;

endmodule