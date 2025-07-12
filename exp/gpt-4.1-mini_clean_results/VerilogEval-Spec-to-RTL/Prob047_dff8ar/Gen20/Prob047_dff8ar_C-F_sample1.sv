// Parameterized vector D flip-flop with asynchronous active-high reset
module DFF_Vector_AsyncReset #(parameter WIDTH = 8) (
    input  wire             clk,
    input  wire             areset,    // Asynchronous active-high reset
    input  wire [WIDTH-1:0] d,
    output reg  [WIDTH-1:0] q
);
    // Asynchronous reset and synchronous data latch
    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= {WIDTH{1'b0}};    // Reset all bits to 0 asynchronously
        else
            q <= d;                // On rising clock edge, capture input
    end
endmodule

module TopModule (
    input  wire        clk,
    input  wire        areset,
    input  wire [7:0]  d,
    output wire [7:0]  q
);
    // Instantiate 8-bit vector D flip-flop with asynchronous reset
    DFF_Vector_AsyncReset #(.WIDTH(8)) dff_inst (
        .clk(clk),
        .areset(areset),
        .d(d),
        .q(q)
    );
endmodule