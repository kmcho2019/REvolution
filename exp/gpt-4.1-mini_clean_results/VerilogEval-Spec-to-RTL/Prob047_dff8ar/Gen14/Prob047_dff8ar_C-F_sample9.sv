module DFF_AR_Vector #(
    parameter WIDTH = 8
) (
    input                   clk,
    input                   areset,
    input  [WIDTH-1:0]      d,
    output reg [WIDTH-1:0]  q
);
    // Explicit asynchronous reset wire for clarity and potential extension
    wire reset_active = areset;

    always @(posedge clk or posedge reset_active) begin
        if (reset_active)
            q <= {WIDTH{1'b0}};
        else
            q <= d;
    end
endmodule

module TopModule (
    input        clk,
    input        areset,
    input  [7:0] d,
    output [7:0] q
);
    DFF_AR_Vector #(.WIDTH(8)) dff_vector_inst (
        .clk(clk),
        .areset(areset),
        .d(d),
        .q(q)
    );
endmodule