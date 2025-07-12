// Parameterized vector D flip-flop with active high asynchronous reset.
// Outputs reset asynchronously to zero on 'areset'.
// On rising edge of 'clk', outputs load input 'd'.
// Non-blocking assignments and explicit initial values improve simulation and synthesis clarity.
module DFF_AsyncReset_Vector #(
    parameter integer WIDTH = 8
) (
    input                   clk,
    input                   areset,
    input  [WIDTH-1:0]      d,
    output reg [WIDTH-1:0]  q
);

    // Initialize output to zero for simulation baseline behavior
    initial begin
        q = {WIDTH{1'b0}};
    end

    // Asynchronous reset and synchronous data loading at posedge clk
    always @(posedge clk or posedge areset) begin
        if (areset) 
            q <= {WIDTH{1'b0}};
        else
            q <= d;
    end

endmodule


// Top-level module instantiates an 8-bit vector DFF with async reset.
module TopModule (
    input         clk,
    input         areset,
    input  [7:0]  d,
    output [7:0]  q
);

    // Instantiate the parameterized DFF vector with named parameter passing and port connections
    DFF_AsyncReset_Vector #(
        .WIDTH(8)
    ) dff_inst (
        .clk    (clk),
        .areset (areset),
        .d      (d),
        .q      (q)
    );

endmodule