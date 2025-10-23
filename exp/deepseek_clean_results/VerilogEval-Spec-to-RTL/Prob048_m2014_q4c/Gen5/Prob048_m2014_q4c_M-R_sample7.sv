module TopModule (
    input clk,
    input d,
    input r,
    output q
);

wire next_q;

// Combinational logic for next state
assign next_q = r ? 1'b0 : d;

// Sequential element (D flip-flop)
DFF dff_inst (
    .D(next_q),
    .CLK(clk),
    .Q(q)
);

endmodule

// Standard D flip-flop primitive
module DFF (
    input D,
    input CLK,
    output reg Q
);
always @(posedge CLK) begin
    Q <= D;
end
endmodule