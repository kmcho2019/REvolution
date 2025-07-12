module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        anyedge <= in ^ prev_in;  // Detect any edge (0->1 or 1->0)
        prev_in <= in;            // Store current input for next cycle
    end

endmodule