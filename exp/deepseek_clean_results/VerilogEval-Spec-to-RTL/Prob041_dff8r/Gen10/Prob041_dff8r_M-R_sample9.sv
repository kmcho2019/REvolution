module DFF #(parameter WIDTH = 1) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);
    wire [WIDTH-1:0] next_q = reset ? {WIDTH{1'b0}} : d;
    
    always @(posedge clk)
        q <= next_q;
endmodule

module TopModule #(parameter WIDTH = 8) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q
);
    DFF #(.WIDTH(WIDTH)) dff_inst (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );
endmodule