module TopModule(
    input           clk,    // clock signal
    input  [7:0]     d,     // 8-bit input data
    output [7:0]    q      // 8-bit output data
);

    // Instantiate 8 D flip-flops, one for each bit of the input data
    reg [7:0] q_reg;        // Internal register to store the output

    always @(posedge clk)  // Trigger the DFFs on the positive edge of the clock
    begin
        q_reg <= d;        // Load the input data into the DFFs
    end

    assign q = q_reg;      // Assign the output of the DFFs to the output port

endmodule