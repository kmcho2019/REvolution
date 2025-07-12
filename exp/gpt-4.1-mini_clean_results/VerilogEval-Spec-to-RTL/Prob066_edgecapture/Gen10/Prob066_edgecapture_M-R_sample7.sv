module TopModule (
    input         clk,
    input         reset,
    input  [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;
    wire [31:0] falling_edge;

    assign falling_edge = prev_in & ~in;  // combinational detection of falling edges

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;   // clear prev_in on reset for defined state
            out <= 32'b0;       // clear output on reset
        end else begin
            out <= out | falling_edge; // latch any detected falling edges
            prev_in <= in;             // update previous input
        end
    end

endmodule