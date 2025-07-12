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
            prev_in <= 32'b0;
            out <= 32'b0;
        end else begin
            prev_in <= in;
            out <= out | falling_edge_detect;
        end
    end

endmodule