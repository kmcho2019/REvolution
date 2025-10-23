// Module for a gate and its corresponding D flip-flop
module GateFF(
    input clk,
    input x,
    input gate_type, // 0 for XOR, 1 for AND, 2 for OR
    output reg ff_out,
    output reg gate_out
);

reg ff_state;

// Sequential logic to update the flip-flop state
always @(posedge clk) begin
    case(gate_type)
        1'b0: ff_state <= x ^ ff_state; // XOR gate
        1'b1: ff_state <= x & ~ff_state; // AND gate
        default: ff_state <= x | ~ff_state; // OR gate
    endcase
end

// Combinational logic to compute the gate output
always @(*) begin
    case(gate_type)
        1'b0: gate_out = x ^ ff_state; // XOR gate
        1'b1: gate_out = x & ~ff_state; // AND gate
        default: gate_out = x | ~ff_state; // OR gate
    endcase
    ff_out = ff_state;
end

// Initial block to initialize the flip-flop state
initial begin
    ff_state = 1'b0;
end

endmodule

// TopModule instantiating the GateFF modules
module TopModule(
    input clk,
    input x,
    output reg z
);

reg xor_ff_out, and_ff_out, or_ff_out;
reg xor_gate_out, and_gate_out, or_gate_out;

// Instantiate the GateFF modules for each gate type
GateFF xor_gate_ff(clk, x, 1'b0, xor_ff_out, xor_gate_out);
GateFF and_gate_ff(clk, x, 1'b1, and_ff_out, and_gate_out);
GateFF or_gate_ff(clk, x, 1'b10, or_ff_out, or_gate_out);

// Combinational logic to compute the final output 'z'
always @(*) begin
    z = ~(xor_ff_out | and_ff_out | or_ff_out);
end

endmodule