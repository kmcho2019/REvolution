// Parameterized vector D flip-flop with asynchronous active-high reset
module DFF_AR #(parameter WIDTH = 1) (
    input  wire             clk,
    input  wire             areset,    // Asynchronous active-high reset
    input  wire [WIDTH-1:0] d,
    output reg  [WIDTH-1:0] q
);
    // Asynchronous reset with posedge clk or posedge areset sensitivity
    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= {WIDTH{1'b0}};   // Reset outputs to zero asynchronously
        else
            q <= d;               // On rising clock edge, latch input data
    end
endmodule

module TopModule (
    input  wire        clk,
    input  wire        areset,
    input  wire [7:0]  d,
    output wire [7:0]  q
);

    // Instantiate parameterized 8-bit asynchronous-reset D flip-flop vector
    DFF_AR #(.WIDTH(8)) dff_inst (
        .clk(clk),
        .areset(areset),
        .d(d),
        .q(q)
    );

endmodule