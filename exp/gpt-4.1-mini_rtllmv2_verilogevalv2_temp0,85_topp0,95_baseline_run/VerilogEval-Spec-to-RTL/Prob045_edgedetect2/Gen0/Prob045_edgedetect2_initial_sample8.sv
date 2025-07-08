module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        // Detect edges by comparing current input to previous input
        anyedge <= in ^ prev_in;
        // Store current input for next cycle comparison
        prev_in <= in;
    end

endmodule