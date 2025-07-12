module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

    reg [7:0] prev_in;  // Stores input from previous cycle

    // Combinational edge detection output
    assign anyedge = in ^ prev_in;

    always @(posedge clk) begin
        // Store current input for next cycle's comparison
        prev_in <= in;
    end

endmodule