// Parameterized vector D flip-flop with asynchronous active-high reset
module DFF_AsyncReset #(
    parameter WIDTH = 1
) (
    input  wire             clk,
    input  wire             areset,     // Asynchronous active-high reset
    input  wire [WIDTH-1:0] d,
    output reg  [WIDTH-1:0] q
);
    // Asynchronous reset asserted immediately; data latched on rising clk edge
    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= {WIDTH{1'b0}};  // Reset outputs to zero asynchronously
        else
            q <= d;              // On rising clock edge, latch input data
    end
endmodule

module TopModule (
    input  wire        clk,
    input  wire        areset,
    input  wire [7:0]  d,
    output wire [7:0]  q
);
    // Instantiate the 8-bit asynchronous-reset vector D flip-flop
    DFF_AsyncReset #(.WIDTH(8)) dff_inst (
        .clk(clk),
        .areset(areset),
        .d(d),
        .q(q)
    );
endmodule