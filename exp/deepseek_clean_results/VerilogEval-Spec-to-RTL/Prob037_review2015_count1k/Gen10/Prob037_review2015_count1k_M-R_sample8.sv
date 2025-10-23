module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

// Next state logic using continuous assignment
wire [9:0] next_q = reset ? 10'd0 : 
                    (q == 10'd999) ? 10'd0 : 
                    q + 1'b1;

always @(posedge clk) begin
    q <= next_q;
end

endmodule