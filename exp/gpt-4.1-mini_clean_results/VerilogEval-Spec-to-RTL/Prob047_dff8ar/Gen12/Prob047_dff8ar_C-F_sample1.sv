// Single-bit D flip-flop with asynchronous active-high reset
module DFF_AsyncReset (
    input  wire clk,
    input  wire areset,
    input  wire d,
    output reg  q
);
    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

// Parameterized vector D flip-flop with asynchronous active-high reset
// Internally instantiate single-bit DFF_AsyncReset modules for clarity and modularity
module DFF_Vector_AsyncReset #(parameter WIDTH = 8) (
    input  wire             clk,
    input  wire             areset,
    input  wire [WIDTH-1:0] d,
    output wire [WIDTH-1:0] q
);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_dffs
            DFF_AsyncReset dff_bit (
                .clk(clk),
                .areset(areset),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate
endmodule

module TopModule (
    input  wire        clk,
    input  wire        areset,
    input  wire [7:0]  d,
    output wire [7:0]  q
);
    // Instantiate 8-bit vector DFF with asynchronous reset using modular 1-bit DFFs
    DFF_Vector_AsyncReset #(.WIDTH(8)) dff_vec_inst (
        .clk(clk),
        .areset(areset),
        .d(d),
        .q(q)
    );
endmodule