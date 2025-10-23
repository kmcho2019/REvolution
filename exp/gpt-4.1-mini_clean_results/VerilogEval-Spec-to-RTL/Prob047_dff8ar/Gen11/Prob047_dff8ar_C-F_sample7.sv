// Parameterized vector D flip-flop with asynchronous active-high reset
module DFF_Vector_AsyncReset #(parameter WIDTH = 8) (
    input  wire             clk,
    input  wire             areset,
    input  wire [WIDTH-1:0] d,
    output reg  [WIDTH-1:0] q
);
    // Asynchronous reset: active high
    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= {WIDTH{1'b0}};
        else
            q <= d;
    end
endmodule

module TopModule (
    input  wire        clk,
    input  wire        areset,
    input  wire [7:0]  d,
    output wire [7:0]  q
);
    // Instantiate 8-bit vector DFF with async reset
    DFF_Vector_AsyncReset #(.WIDTH(8)) dff_inst (
        .clk(clk),
        .areset(areset),
        .d(d),
        .q(q)
    );
endmodule