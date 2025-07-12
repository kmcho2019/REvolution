module TopModule (
    input        clk,     // Clock input, positive edge triggered
    input        areset,  // Active high asynchronous reset
    input  [7:0] d,       // 8-bit data input
    output [7:0] q        // 8-bit data output
);

    reg [7:0] q_reg;

    // Initialize output to 0 to prevent X states in simulation
    initial q_reg = 8'b0;

    // Generate block to create one flip-flop per bit
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : bit_flipflops
            always @(posedge clk or posedge areset) begin
                if (areset)
                    q_reg[i] <= 1'b0;
                else
                    q_reg[i] <= d[i];
            end
        end
    endgenerate

    assign q = q_reg;

endmodule