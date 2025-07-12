// Define a submodule for the gate and D flip-flop
module GateFF(
    input clk,
    input x,
    input [1:0] gate_type, // 0: XOR, 1: AND, 2: OR
    output reg q
);

reg q_prev; // Previous output of the D flip-flop

// Combinational logic for the gate
wire gate_out;

always @(*) begin
    case(gate_type)
        2'b00: gate_out = x ^ q_prev; // XOR gate
        2'b01: gate_out = x & ~q_prev; // AND gate
        2'b10: gate_out = x | ~q_prev; // OR gate
    endcase
end

// Sequential logic to update the D flip-flop
always @(posedge clk) begin
    q_prev <= gate_out;
    q <= gate_out;
end

endmodule

// Define the top-level module
module TopModule(
    input clk,
    input x,
    output reg z
);

wire xor_out, and_out, or_out;

// Instantiate the submodules for each gate and D flip-flop
GateFF xor_ff(
   .clk(clk),
   .x(x),
   .gate_type(2'b00),
   .q(xor_out)
);

GateFF and_ff(
   .clk(clk),
   .x(x),
   .gate_type(2'b01),
   .q(and_out)
);

GateFF or_ff(
   .clk(clk),
   .x(x),
   .gate_type(2'b10),
   .q(or_out)
);

// Combinational logic to compute the output 'z'
assign z = ~(~xor_out | ~and_out | ~or_out);

endmodule