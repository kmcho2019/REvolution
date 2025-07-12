module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire clk_enable = shift_ena | count_ena;
wire gated_clk;

// Clock gating cell (synthesis will infer proper clock gating)
assign gated_clk = clk & clk_enable;

always @(posedge gated_clk) begin
    if (shift_ena) begin
        // Shift operation (MSB first)
        q <= {q[2:0], data};
    end
    else begin // count_ena is implied by clock gating
        // Decrement using adder implementation (q + 4'b1111)
        q <= q + 4'b1111;
    end
end

endmodule