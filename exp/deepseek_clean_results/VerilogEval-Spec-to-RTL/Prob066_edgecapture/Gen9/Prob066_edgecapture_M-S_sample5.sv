module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] captured;

    always @(posedge clk) begin
        if (reset) begin
            captured <= 32'b0;
        end
        else begin
            // Detect and capture falling edges (1->0 transitions)
            // Uses previous cycle's input (captured) for comparison
            captured <= captured | (captured & ~in);
        end
    end

    assign out = captured;

endmodule