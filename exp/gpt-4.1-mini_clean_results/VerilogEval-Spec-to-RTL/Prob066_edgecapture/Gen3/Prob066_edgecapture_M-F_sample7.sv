module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;  // Register to hold previous cycle's input

    wire [31:0] falling_edge_detect = prev_in & ~in;

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            prev_in <= in;   // Initialize prev_in to current input on reset to avoid false detection
        end else begin
            out <= out | falling_edge_detect;
            prev_in <= in;
        end
    end

endmodule