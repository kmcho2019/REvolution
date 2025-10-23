module TopModule (
    input clk,            // Clock input
    input [7:0] in,       // 8-bit input vector
    output reg [7:0] pedge // Positive edge detection outputs
);

    reg [7:0] prev_in;    // Stores previous input values for edge detection

    always @(posedge clk) begin
        // Store current input for next cycle comparison
        prev_in <= in;
        
        // Detect positive edges (0->1 transitions) for each bit
        pedge <= in & ~prev_in;
    end

endmodule