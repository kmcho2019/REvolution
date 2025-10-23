// Parameterized vector D flip-flop with asynchronous active-high reset
module DFF_AsyncReset #(parameter WIDTH = 8) (
    input  wire             clk,
    input  wire             areset,     // Asynchronous active-high reset
    input  wire [WIDTH-1:0] d,
    output reg  [WIDTH-1:0] q
);
    // Asynchronous reset triggered on posedge of areset or clk
    // Non-blocking assignments used for proper synthesis of sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q <= {WIDTH{1'b0}};  // Reset outputs asynchronously to zero
        end else begin
            q <= d;              // Latch input data on rising clock edge
        end
    end
endmodule

module TopModule (
    input  wire        clk,
    input  wire        areset,
    input  wire [7:0]  d,
    output wire [7:0]  q
);
    // Instantiate parameterized 8-bit DFF vector with async reset
    DFF_AsyncReset #(.WIDTH(8)) dff_inst (
        .clk(clk),
        .areset(areset),
        .d(d),
        .q(q)
    );
endmodule