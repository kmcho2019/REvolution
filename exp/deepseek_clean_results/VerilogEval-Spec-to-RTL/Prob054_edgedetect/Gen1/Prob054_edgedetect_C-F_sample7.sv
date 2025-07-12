module TopModule (
    input clk,            // Clock input
    input [7:0] in,       // 8-bit input vector
    output reg [7:0] pedge // Positive edge detection outputs
);

    reg [7:0] prev_in;    // Stores input values from previous cycle

    always @(posedge clk) begin
        // Store current input values for next cycle comparison
        prev_in <= in;
        
        // Detect 0->1 transitions: current=1 AND previous=0
        pedge <= in & ~prev_in;
    end

endmodule