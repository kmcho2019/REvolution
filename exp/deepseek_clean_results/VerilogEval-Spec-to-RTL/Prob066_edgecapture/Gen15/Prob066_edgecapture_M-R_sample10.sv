module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev_in_reg = 32'b0;
    reg [31:0] captured = 32'b0;
    wire [31:0] falling_edge;

    // Combinational logic for edge detection
    assign falling_edge = prev_in_reg & ~in;
    assign out = captured;

    always @(posedge clk) begin
        if (reset) begin
            prev_in_reg <= 32'b0;
            captured <= 32'b0;
        end
        else begin
            // Update captured state (sticky until reset)
            captured <= captured | falling_edge;
            // Update previous input register
            prev_in_reg <= in;
        end
    end

endmodule