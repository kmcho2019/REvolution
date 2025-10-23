// Define the D flip-flop module with an XOR gate
module DFFXOR(
    input clk,
    input reset,
    input x,
    output reg q,
    output out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 1'b0;
    end else begin
        q <= x ^ q;
    end
end

assign out = q;

endmodule

// Define the D flip-flop module with an AND gate
module DFFAND(
    input clk,
    input reset,
    input x,
    output reg q,
    output out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 1'b0;
    end else begin
        q <= x & ~q;
    end
end

assign out = q;

endmodule

// Define the D flip-flop module with an OR gate
module DFFOR(
    input clk,
    input reset,
    input x,
    output reg q,
    output out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 1'b0;
    end else begin
        q <= x | ~q;
    end
end

assign out = q;

endmodule

// Define the TopModule
module TopModule(
    input clk,
    input x,
    output z
);

wire xor_out, and_out, or_out;

// Instantiate the DFF modules for each gate type
DFFXOR xor_gate(
  .clk(clk),
  .reset(1'b0),
  .x(x),
  .q(),
  .out(xor_out)
);

DFFAND and_gate(
  .clk(clk),
  .reset(1'b0),
  .x(x),
  .q(),
  .out(and_out)
);

DFFOR or_gate(
  .clk(clk),
  .reset(1'b0),
  .x(x),
  .q(),
  .out(or_out)
);

// Combine the outputs using a NOR gate
assign z = ~(xor_out | and_out | or_out);

endmodule