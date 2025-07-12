module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] captured;  // sticky capture register

    always @(posedge clk) begin
        if (reset) begin
            captured <= 32'b0;
        end
        else begin
            captured <= captured | (~in & (captured ^ ~in));  // Simplified edge detection
        end
    end

    assign out = captured;

endmodule