module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

    reg [7:0] prev_in;

    // Continuous assignment for edge detection
    assign anyedge = in ^ prev_in;

    always @(posedge clk) begin
        // Store current input for next cycle comparison
        prev_in <= in;
    end

endmodule