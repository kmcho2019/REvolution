module DFF_AR_Vector_En #(
    parameter WIDTH = 8
) (
    input                   clk,
    input                   areset,
    input                   en,          // enable signal for loading new data
    input  [WIDTH-1:0]      d,
    output reg [WIDTH-1:0]  q
);
    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= {WIDTH{1'b0}};
        else if (en)
            q <= d;
    end
endmodule

module TopModule (
    input        clk,
    input        areset,
    input  [7:0] d,
    output [7:0] q
);
    // Generate enable only when input data differs from current q to reduce switching
    wire load_en = (d != q);

    DFF_AR_Vector_En #(.WIDTH(8)) dff_vector_inst (
        .clk(clk),
        .areset(areset),
        .en(load_en),
        .d(d),
        .q(q)
    );
endmodule