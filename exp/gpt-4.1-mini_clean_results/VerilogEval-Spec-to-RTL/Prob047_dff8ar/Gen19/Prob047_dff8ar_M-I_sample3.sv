// Parameterized vector D flip-flop with asynchronous active-high reset and conditional update
module DFF_Vector_AsyncReset #(parameter WIDTH = 8) (
    input  wire             clk,
    input  wire             areset,    // Asynchronous active-high reset
    input  wire [WIDTH-1:0] d,
    output reg  [WIDTH-1:0] q
);
    // Asynchronous reset and conditional update to minimize switching activity
    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= {WIDTH{1'b0}};           // Reset output vector to zero asynchronously
        else if (q !== d)
            q <= d;                      // Update output only if input changes
    end
endmodule

module TopModule (
    input  wire        clk,
    input  wire        areset,
    input  wire [7:0]  d,
    output wire [7:0]  q
);
    // Instantiate 8-bit DFF vector with async reset and conditional update
    DFF_Vector_AsyncReset #(.WIDTH(8)) dff_inst (
        .clk(clk),
        .areset(areset),
        .d(d),
        .q(q)
    );
endmodule