module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire [3:0] next_q;
wire counter_enable;

// Combinational next state logic
assign next_q = (q == 4'b1111) ? 4'b0000 : q + 1'b1;
assign counter_enable = (q != 4'b1111) || reset;

// Sequential logic with clock gating
always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else if (counter_enable) begin
        q <= next_q;
    end
end

endmodule