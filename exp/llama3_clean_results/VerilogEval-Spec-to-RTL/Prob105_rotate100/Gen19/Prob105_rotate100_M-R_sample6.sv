module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;

// Combinational Logic
wire [99:0] next_q;

assign next_q = (load) ? data : 
                (ena == 2'b01) ? {q_reg[0], q_reg[99:1]} : 
                (ena == 2'b10) ? {q_reg[98:0], q_reg[99]} : q_reg;

// Sequential Logic
always @(posedge clk) begin
    q_reg <= next_q;
end

// Output Logic
assign q = q_reg;

endmodule