module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    wire [7:0] prev_in;
    wire [7:0] next_prev_in = in;
    wire [7:0] next_pedge = in & ~prev_in;

    // Flip-flop for previous input
    dff #(8) prev_in_ff (
        .clk(clk),
        .d(next_prev_in),
        .q(prev_in)
    );

    // Flip-flop for output
    dff #(8) pedge_ff (
        .clk(clk),
        .d(next_pedge),
        .q(pedge)
    );

endmodule

// Simple D flip-flop module
module dff #(parameter WIDTH=1) (
    input clk,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule