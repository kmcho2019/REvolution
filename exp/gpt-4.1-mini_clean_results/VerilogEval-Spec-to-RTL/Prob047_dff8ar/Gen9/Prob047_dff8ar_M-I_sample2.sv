module DFF_AR_Vector_ClockEnable #(
    parameter WIDTH = 8
) (
    input                   clk,
    input                   areset,
    input                   clk_en,
    input  [WIDTH-1:0]      d,
    output reg [WIDTH-1:0]  q
);
    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= {WIDTH{1'b0}};
        else if (clk_en)
            q <= d;
    end
endmodule

module TopModule (
    input        clk,
    input        areset,
    input  [7:0] d,
    output [7:0] q
);
    // Generate clock enable: update only if input data changes or on reset
    wire clk_en;
    assign clk_en = areset | (d != q);

    // Instantiate 8-bit async reset DFF vector with clock enable
    DFF_AR_Vector_ClockEnable #(.WIDTH(8)) dff_vector_inst (
        .clk(clk),
        .areset(areset),
        .clk_en(clk_en),
        .d(d),
        .q(q)
    );
endmodule