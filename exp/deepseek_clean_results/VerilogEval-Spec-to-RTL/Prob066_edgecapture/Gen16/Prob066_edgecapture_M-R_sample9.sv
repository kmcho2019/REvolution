module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev_in;
    reg [31:0] captured;

    // Output is registered captured edges
    assign out = captured;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            captured <= 32'b0;
        end
        else begin
            prev_in <= in;
            // Capture new falling edges OR maintain existing captures
            captured <= (prev_in & ~in) | captured;
        end
    end

endmodule