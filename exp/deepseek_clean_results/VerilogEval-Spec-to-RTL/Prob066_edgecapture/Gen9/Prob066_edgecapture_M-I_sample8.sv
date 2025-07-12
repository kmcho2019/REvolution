module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev_in;
    reg [31:0] captured;
    wire [31:0] falling_edge;

    // Combinational logic for falling edge detection
    assign falling_edge = prev_in & ~in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            captured <= 32'b0;
        end
        else begin
            prev_in <= in;
            // Capture any falling edges and maintain sticky bits
            captured <= captured | falling_edge;
        end
    end

    assign out = captured;

endmodule