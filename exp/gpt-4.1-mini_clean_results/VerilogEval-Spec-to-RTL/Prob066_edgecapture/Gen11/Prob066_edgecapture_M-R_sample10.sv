module TopModule (
    input         clk,
    input         reset,
    input  [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;
    wire [31:0] falling_edges;

    // Combinational detection of falling edges: previous bit 1 and current bit 0
    assign falling_edges = prev_in & (~in);

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            out <= 32'b0;
        end else begin
            out <= out | falling_edges;  // capture falling edges
            prev_in <= in;               // update previous input
        end
    end

endmodule