module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

wire [3:0] next_q;
wire enable = slowena & ~reset;

// Combinational next state logic
assign next_q = (q == 4'b1001) ? 4'b0000 : q + 1'b1;

// Sequential state update
always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else if (enable) begin
        q <= next_q;
    end
end

endmodule