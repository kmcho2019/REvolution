module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;
    wire [31:0] falling_edge;

    // Combinational logic for edge detection
    assign falling_edge = prev_in & ~in;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            prev_in <= 32'b0;
        end else begin
            out <= out | falling_edge;  // Sticky output
            prev_in <= in;
        end
    end

endmodule