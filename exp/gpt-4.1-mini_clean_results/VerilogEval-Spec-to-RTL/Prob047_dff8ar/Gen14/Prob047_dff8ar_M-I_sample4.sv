module DFF_AR_Vector #(
    parameter WIDTH = 8
) (
    input                   clk,
    input                   areset,     // Active-high asynchronous reset
    input  [WIDTH-1:0]      d,
    output reg [WIDTH-1:0]  q
);
    // Asynchronous reset flip-flops with positive edge clock triggering
    // Enable updating only when input data differs from current output or on reset
    wire update_en = areset | (q != d);

    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= {WIDTH{1'b0}};    // Reset output to zero asynchronously
        else if (update_en)
            q <= d;                // Capture new data only if changed
    end
endmodule

module TopModule (
    input        clk,
    input        areset,
    input  [7:0] d,
    output [7:0] q
);
    // Instantiate 8-bit vector DFF with async reset and data-change enable to reduce switching
    DFF_AR_Vector #(.WIDTH(8)) dff_vector_inst (
        .clk(clk),
        .areset(areset),
        .d(d),
        .q(q)
    );
endmodule