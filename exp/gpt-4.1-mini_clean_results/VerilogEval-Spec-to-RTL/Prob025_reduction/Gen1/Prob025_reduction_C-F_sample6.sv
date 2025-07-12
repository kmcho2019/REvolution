module TopModule (
    input  wire        clk,    // Clock input for registering parity output
    input  wire [7:0]  in,     // 8-bit input data
    output reg         parity  // Registered even parity output
);
    wire parity_comb;
    // Compute even parity by XOR reduction of all bits
    assign parity_comb = ^in;

    // Register parity output to reduce glitches and improve timing closure
    always @(posedge clk) begin
        parity <= parity_comb;
    end
endmodule