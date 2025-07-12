module JC_counter(
    input wire clk,
    input wire rst_n,
    output reg [63:0] Q
);

wire feedback_bit = (Q[0] == 1'b0) ? 1'b1 : 1'b0;

integer i;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        // Shift right by one position, insert feedback_bit at MSB
        // Implement explicit shifting to reduce combinational fanout and improve timing
        Q[63] <= feedback_bit;
        for (i = 62; i >= 0; i = i - 1) begin
            Q[i] <= Q[i+1];
        end
    end
end

endmodule