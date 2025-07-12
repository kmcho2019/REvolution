module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Combinational logic for next count value
wire [3:0] next_q = q + 1'b1;

always @(posedge clk) begin
    if (reset)
        q <= 4'b0000;
    else
        q <= next_q;
end

endmodule