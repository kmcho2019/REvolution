module TopModule (
    input wire clk,    // Clock input, positive edge triggered
    input wire d,      // Data input to flip-flop
    output reg q       // Output of the flip-flop, registered on clk rising edge
);

    // On each positive edge of clk, capture the value of d into q
    always @(posedge clk) begin
        q <= d;
    end

endmodule