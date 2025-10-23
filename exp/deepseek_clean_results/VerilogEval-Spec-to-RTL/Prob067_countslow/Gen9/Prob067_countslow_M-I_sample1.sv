module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

wire [3:0] next_q;

// Combinational logic for next state (simplified)
assign next_q = (slowena) ? ((q == 4'd9) ? 4'd0 : q + 4'd1) : q;

// Sequential logic with reset
always @(posedge clk) begin
    if (reset)
        q <= 4'd0;
    else
        q <= next_q;
end

endmodule