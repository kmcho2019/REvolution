module TopModule (
    input clk,
    input a,
    output q
);

wire d;
assign d = ~a;  // Combinational inversion

// Structural D flip-flop implementation
DFF dff_inst (
    .clk(clk),
    .d(d),
    .q(q)
);

endmodule

// D flip-flop primitive definition
module DFF (
    input clk,
    input d,
    output reg q
);
always @(posedge clk) begin
    q <= d;
end
endmodule