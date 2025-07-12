module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] captured;
    reg [31:0] prev_in;
    wire [31:0] falling_edge;

    // Combinational falling edge detection
    assign falling_edge = prev_in & ~in;

    always @(posedge clk) begin
        if (reset) begin
            captured <= 32'b0;
            prev_in <= 32'b0;
        end
        else begin
            // Update captured bits (sticky until reset)
            captured <= captured | falling_edge;
            // Store current input for next edge detection
            prev_in <= in;
        end
    end

    assign out = captured;

endmodule