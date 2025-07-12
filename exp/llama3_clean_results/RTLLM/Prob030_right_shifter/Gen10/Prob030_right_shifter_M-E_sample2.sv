module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q_next;

always @(posedge clk) begin
    q_next[7] = d;
    for (int i = 6; i >= 0; i--) begin
        q_next[i] = q[i + 1];
    end
    q <= q_next;
end

endmodule