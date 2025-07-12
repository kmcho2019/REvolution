module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire clk_enable = shift_ena | count_ena;
wire gated_clk = clk & clk_enable;

wire [1:0] operation = {shift_ena, count_ena};
wire [3:0] next_q;

// Combinational logic for next state
assign next_q = (operation == 2'b10) ? {q[2:0], data} :  // Shift operation
                (operation == 2'b01) ? q - 1'b1 :       // Count operation
                q;                                      // Hold value

// Sequential element with clock gating
always @(posedge gated_clk) begin
    q <= next_q;
end

endmodule