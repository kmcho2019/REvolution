module DFF_Vector_AsyncReset #(
    parameter WIDTH = 8
) (
    input                   clk,
    input                   areset,
    input  [WIDTH-1:0]      d,
    output reg [WIDTH-1:0]  q
);
    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= {WIDTH{1'b0}};
        else
            q <= d;
    end
endmodule

module TopModule (
    input         clk,
    input         areset,
    input  [7:0]  d,
    output [7:0]  q
);
    // Instantiate parameterized 8-bit async reset vector DFF
    DFF_Vector_AsyncReset #(8) dff_vector_inst (
        .clk(clk),
        .areset(areset),
        .d(d),
        .q(q)
    );
endmodule