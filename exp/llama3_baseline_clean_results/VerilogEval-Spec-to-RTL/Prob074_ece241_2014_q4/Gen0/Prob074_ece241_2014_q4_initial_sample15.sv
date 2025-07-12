module TopModule(
    input clk,
    input x,
    output z
);

// Internal wires
wire xor_out, and_out, or_out;
wire xor_ff_out, and_ff_out, or_ff_out;
wire xor_ff_out_n, and_ff_out_n, or_ff_out_n;

// Gates
assign xor_out = x ^ xor_ff_out;
assign and_out = x & (~and_ff_out);
assign or_out = x | or_ff_out_n;

// D Flip-Flops
DFF xor_ff(.clk(clk),.d(xor_out),.q(xor_ff_out));
DFF and_ff(.clk(clk),.d(and_out),.q(and_ff_out));
DFF or_ff(.clk(clk),.d(or_out),.q(or_ff_out));

// Complements for internal signals
assign xor_ff_out_n = ~xor_ff_out;
assign and_ff_out_n = ~and_ff_out;
assign or_ff_out_n = ~or_ff_out;

// Final NOR gate
assign z = ~(xor_ff_out | and_ff_out | or_ff_out);

// D Flip-Flop module definition
module DFF(
    input clk,
    input d,
    output q
);
reg q_reg;
initial q_reg = 1'b0;
always @(posedge clk) begin
    q_reg <= d;
end
assign q = q_reg;
endmodule

endmodule