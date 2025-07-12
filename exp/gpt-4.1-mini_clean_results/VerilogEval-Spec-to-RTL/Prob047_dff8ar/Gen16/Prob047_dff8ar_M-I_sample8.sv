// Parameterized vector D flip-flop with synchronous active-high reset
module DFF_Vector_SyncReset #(parameter WIDTH = 8) (
    input  wire             clk,
    input  wire             areset,    // Synchronous active-high reset
    input  wire [WIDTH-1:0] d,
    output reg  [WIDTH-1:0] q
);
    // Synchronous reset on clock edge
    always @(posedge clk) begin
        if (areset)
            q <= {WIDTH{1'b0}};    // Reset output vector to zero synchronously
        else
            q <= d;                // On clock edge, latch input data
    end
endmodule

module TopModule (
    input  wire        clk,
    input  wire        areset,
    input  wire [7:0]  d,
    output wire [7:0]  q
);
    // Instantiate 8-bit vector DFF with synchronous reset
    DFF_Vector_SyncReset #(.WIDTH(8)) dff_inst (
        .clk(clk),
        .areset(areset),
        .d(d),
        .q(q)
    );
endmodule