module TopModule #(
    parameter WIDTH = 8    // Configurable width (default 8)
) (
    input clk,             // Clock input
    input reset,           // Active-high synchronous reset
    input [WIDTH-1:0] in,  // Input vector
    output reg [WIDTH-1:0] pedge // Positive edge detection outputs
);

    reg [WIDTH-1:0] prev_in;  // Stores previous input values

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= {WIDTH{1'b0}};
            pedge <= {WIDTH{1'b0}};
        end
        else begin
            // Store current input for next cycle comparison
            prev_in <= in;
            
            // Detect 0->1 transitions: current=1 AND previous=0
            pedge <= in & ~prev_in;
        end
    end

endmodule