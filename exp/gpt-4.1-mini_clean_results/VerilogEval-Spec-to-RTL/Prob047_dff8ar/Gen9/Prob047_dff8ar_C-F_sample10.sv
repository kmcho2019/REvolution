module DFF_Vector_AsyncReset #(parameter WIDTH = 8) (
    input                  clk,
    input                  areset,
    input  [WIDTH-1:0]     d,
    output reg [WIDTH-1:0] q
);
    // Asynchronous reset active high
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
    // Instantiate vectorized DFF with async reset
    DFF_Vector_AsyncReset #(8) dff_vec_inst (
        .clk(clk),
        .areset(areset),
        .d(d),
        .q(q)
    );
endmodule