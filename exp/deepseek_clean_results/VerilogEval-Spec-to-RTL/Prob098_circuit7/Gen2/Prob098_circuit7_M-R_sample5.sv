module TopModule (
    input clk,
    input a,
    output q
);

wire d;

// Combinational logic
assign d = ~a;  // Inverted a becomes the D input

// Sequential element
DFF dff_inst (
    .clk(clk),
    .d(d),
    .q(q)
);

endmodule

// D Flip-Flop module
module DFF (
    input clk,
    input d,
    output reg q
);

always @(posedge clk) begin
    q <= d;
end

endmodule