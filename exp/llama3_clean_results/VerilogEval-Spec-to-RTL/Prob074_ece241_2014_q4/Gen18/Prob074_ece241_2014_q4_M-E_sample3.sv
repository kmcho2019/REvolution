module GateModule(
    input clk,
    input reset,
    input x,
    output reg q,
    output out
);

reg gate_out;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 1'b0;
    end else begin
        case (x)
            1'b0: gate_out <= 1'b0;
            1'b1: gate_out <= ~q; // For XOR gate
            // For AND gate: gate_out <= x & ~q;
            // For OR gate: gate_out <= x | ~q;
        endcase
        q <= gate_out;
    end
end

assign out = gate_out;

endmodule

module TopModule(
    input clk,
    input x,
    output z
);

wire xor_out, and_out, or_out;

GateModule xor_gate(
   .clk(clk),
   .reset(1'b0),
   .x(x),
   .q(),
   .out(xor_out)
);

GateModule and_gate(
   .clk(clk),
   .reset(1'b0),
   .x(x),
   .q(),
   .out(and_out)
);

GateModule or_gate(
   .clk(clk),
   .reset(1'b0),
   .x(x),
   .q(),
   .out(or_out)
);

assign z = ~(xor_out | and_out | or_out);

endmodule

// Modify the GateModule to support different gate types
module GateModuleXOR(
    input clk,
    input reset,
    input x,
    output reg q,
    output out
);

reg gate_out;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 1'b0;
    end else begin
        gate_out <= x ^ q;
        q <= gate_out;
    end
end

assign out = gate_out;

endmodule

module GateModuleAND(
    input clk,
    input reset,
    input x,
    output reg q,
    output out
);

reg gate_out;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 1'b0;
    end else begin
        gate_out <= x & ~q;
        q <= gate_out;
    end
end

assign out = gate_out;

endmodule

module GateModuleOR(
    input clk,
    input reset,
    input x,
    output reg q,
    output out
);

reg gate_out;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 1'b0;
    end else begin
        gate_out <= x | ~q;
        q <= gate_out;
    end
end

assign out = gate_out;

endmodule

// Use the modified GateModule instances
module TopModule(
    input clk,
    input x,
    output z
);

wire xor_out, and_out, or_out;

GateModuleXOR xor_gate(
   .clk(clk),
   .reset(1'b0),
   .x(x),
   .q(),
   .out(xor_out)
);

GateModuleAND and_gate(
   .clk(clk),
   .reset(1'b0),
   .x(x),
   .q(),
   .out(and_out)
);

GateModuleOR or_gate(
   .clk(clk),
   .reset(1'b0),
   .x(x),
   .q(),
   .out(or_out)
);

assign z = ~(xor_out | and_out | or_out);

endmodule