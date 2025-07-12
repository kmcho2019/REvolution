module TopModule (
    input        clk,
    input  [7:0] d,
    output reg [7:0] q
);

    // Initialize q to zero to avoid unknown states in simulation
    initial q = 8'b0;

    always @(posedge clk)
        q <= d;

endmodule