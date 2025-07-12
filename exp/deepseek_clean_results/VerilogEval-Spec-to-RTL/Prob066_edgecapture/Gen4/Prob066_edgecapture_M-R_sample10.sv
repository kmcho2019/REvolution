module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev_in;
    reg [31:0] captured;
    wire [31:0] falling_edge;

    // Detect falling edges
    assign falling_edge = prev_in & ~in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            captured <= 32'b0;
        end else begin
            // First capture any new falling edges
            captured <= captured | falling_edge;
            // Then update previous input for next cycle
            prev_in <= in;
        end
    end

    assign out = captured;

endmodule