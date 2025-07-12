module JC_counter (
    input wire clk,
    input wire rst_n,
    output reg [63:0] Q
);

// 64-bit Johnson (torsional ring) counter
// On reset (active low), Q is cleared to 0
// On each rising clk edge:
// - If Q[0] == 0, shift right and insert 1 at MSB
// - Else, shift right and insert 0 at MSB

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        if (Q[0] == 1'b0)
            Q <= {1'b1, Q[63:1]};
        else
            Q <= {1'b0, Q[63:1]};
    end
end

endmodule