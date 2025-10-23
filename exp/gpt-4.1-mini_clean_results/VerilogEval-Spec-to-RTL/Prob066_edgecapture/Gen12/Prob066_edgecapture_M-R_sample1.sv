module TopModule (
    input              clk,
    input              reset,
    input      [31:0]  in,
    output reg [31:0]  out
);

    reg [31:0] prev_in;
    wire [31:0] falling_edges;

    // Combinational detection of falling edges (1 -> 0 transitions)
    assign falling_edges = prev_in & ~in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            out <= 32'b0;
        end else begin
            prev_in <= in;          // register current input for next cycle comparison
            out <= out | falling_edges; // latch falling edges detected
        end
    end

endmodule