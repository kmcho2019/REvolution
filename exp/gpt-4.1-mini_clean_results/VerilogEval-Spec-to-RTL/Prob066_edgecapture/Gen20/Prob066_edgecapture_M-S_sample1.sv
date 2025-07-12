module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] in,
    output reg  [31:0] out
);

    reg [31:0] prev_in;

    wire [31:0] falling_edge = prev_in & ~in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'hFFFFFFFF; // initialize to all ones to catch falling edges on first zero input
            out <= 32'b0;
        end else begin
            prev_in <= in;
            out <= out | falling_edge;
        end
    end

endmodule