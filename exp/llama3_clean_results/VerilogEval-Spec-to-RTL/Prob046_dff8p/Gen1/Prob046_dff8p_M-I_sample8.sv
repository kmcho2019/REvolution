module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg; // internal reg for storing flip-flop values

assign q = q_reg; // continuously assign q_reg to output port q

always @(negedge clk) begin
    if (reset) begin
        q_reg <= 8'h34; // synchronous reset to 0x34
    end else begin
        q_reg <= d; // update q_reg with input d on negedge of clk
    end
end

endmodule