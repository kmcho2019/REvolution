module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in_1, prev_in_2;

    always @(posedge clk) begin
        // First pipeline stage: capture inputs
        prev_in_1 <= in;
        prev_in_2 <= prev_in_1;
        
        // Second pipeline stage: edge detection
        anyedge <= (in & ~prev_in_1) | (~in & prev_in_1);
    end

endmodule