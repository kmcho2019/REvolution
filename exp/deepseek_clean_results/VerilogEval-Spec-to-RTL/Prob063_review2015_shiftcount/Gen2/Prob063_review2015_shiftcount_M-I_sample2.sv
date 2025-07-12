module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire [3:0] next_q;

// Combinational logic for next state
assign next_q = shift_ena ? {q[2:0], data} : 
                count_ena ? q - 1'b1 : 
                q;

// Clock gating logic (synthesis tool may implement this optimally)
wire clk_enable = shift_ena | count_ena;
wire gated_clk = clk & clk_enable;

// Sequential logic with gated clock
always @(posedge gated_clk) begin
    q <= next_q;
end

endmodule