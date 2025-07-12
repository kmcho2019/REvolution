module TopModule (
    input clk,            // Clock input
    input [7:0] in,       // 8-bit input vector
    output reg [7:0] pedge // Positive edge detection outputs
);

    reg [7:0] prev_in;    // Stores input values from previous cycle
    wire clk_en;          // Clock enable signal
    reg [7:0] prev_in_gated; // Gated version of prev_in

    // Clock gating control - enable only when input changes
    assign clk_en = (in != prev_in_gated);

    always @(posedge clk) begin
        // Store current input values for next cycle comparison
        // Only update when input has changed (clock gating)
        if (clk_en) begin
            prev_in <= in;
            prev_in_gated <= in;
        end
        
        // Detect 0->1 transitions: current=1 AND previous=0
        pedge <= in & ~prev_in;
    end

endmodule