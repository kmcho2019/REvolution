// Define the D flip-flop module with a gate
module DFFGate(
    input clk,
    input reset,
    input x,
    input gate_type, // 2'b00 for XOR, 2'b01 for AND, 2'b10 for OR
    output reg q,
    output out
);

reg gate_out;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 1'b0;
    end else begin
        case (gate_type)
            2'b00: gate_out <= x ^ q; // XOR
            2'b01: gate_out <= x & ~q; // AND
            2'b10: gate_out <= x | ~q; // OR
        endcase
        q <= gate_out;
    end
end

assign out = gate_out;

endmodule

// Define the TopModule
module TopModule(
    input clk,
    input x,
    output z
);

wire xor_out, and_out, or_out;

// Instantiate the DFFGate modules for each gate type
DFFGate xor_gate(
  .clk(clk),
  .reset(1'b0),
  .x(x),
  .gate_type(2'b00),
  .q(),
  .out(xor_out)
);

DFFGate and_gate(
  .clk(clk),
  .reset(1'b0),
  .x(x),
  .gate_type(2'b01),
  .q(),
  .out(and_out)
);

DFFGate or_gate(
  .clk(clk),
  .reset(1'b0),
  .x(x),
  .gate_type(2'b10),
  .q(),
  .out(or_out)
);

// Combine the outputs using a NOR gate
assign z = ~(xor_out | and_out | or_out);

endmodule