module JC_counter (
    input  wire       clk,
    input  wire       rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Asynchronous reset: initialize counter to zero
        Q <= 64'b0;
    end else begin
        // Shift right by one bit and insert inverted Q[0] at MSB
        // This implements the 64-bit Johnson (torsional ring) counter logic:
        // If Q[0] == 0, insert 1 at MSB; if Q[0] == 1, insert 0 at MSB.
        Q <= {~Q[0], Q[63:1]};
    end
end

endmodule