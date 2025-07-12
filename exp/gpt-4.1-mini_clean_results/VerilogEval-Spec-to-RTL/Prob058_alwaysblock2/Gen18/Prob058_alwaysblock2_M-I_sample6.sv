module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output wire out_always_comb,
    output reg  out_always_ff
);

// Direct combinational XOR assignment for out_assign
assign out_assign = a ^ b;

// Replace combinational always block with assign for out_always_comb
assign out_always_comb = a ^ b;

// Clock enable: register only updates on input change to reduce toggling
wire inputs_changed = (out_always_ff != (a ^ b));

always @(posedge clk) begin
    if (inputs_changed)
        out_always_ff <= a ^ b;
end

endmodule