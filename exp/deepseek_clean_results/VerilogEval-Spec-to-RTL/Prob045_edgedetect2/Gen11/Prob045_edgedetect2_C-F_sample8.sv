module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        prev_in <= in;           // Store current input for next cycle
        anyedge <= in ^ prev_in; // Detect edges on all 8 bits in parallel
    end

endmodule