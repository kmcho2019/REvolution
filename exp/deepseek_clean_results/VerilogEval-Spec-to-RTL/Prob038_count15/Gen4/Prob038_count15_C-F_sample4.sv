module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Combinational next-state logic
wire [3:0] next_q = q + 1;

// Sequential state update with synchronous reset
always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else begin
        q <= next_q;
    end
end

endmodule