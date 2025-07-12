module JC_counter(
    input wire clk,
    input wire rst_n,
    output reg [63:0] Q
);

wire feedback_bit;

assign feedback_bit = (Q[0] == 1'b0) ? 1'b1 : 1'b0;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        Q <= {feedback_bit, Q[63:1]};
    end
end

endmodule