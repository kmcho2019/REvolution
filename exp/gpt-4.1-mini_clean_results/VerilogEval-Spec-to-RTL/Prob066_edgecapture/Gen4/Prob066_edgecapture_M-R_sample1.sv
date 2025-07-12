module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;

    wire [31:0] falling_edges;
    assign falling_edges = prev_in & ~in; // falling edge: prev_in=1 and in=0

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            out <= 32'b0;
        end else begin
            out <= out | falling_edges;
            prev_in <= in;
        end
    end

endmodule