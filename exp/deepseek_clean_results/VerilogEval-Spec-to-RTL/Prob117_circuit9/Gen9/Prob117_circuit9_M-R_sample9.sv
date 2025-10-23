module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

wire [2:0] next_q;

// Combinational next state logic
assign next_q = a ? 3'd4 :        // synchronous reset to 4 when a=1
                (q == 3'd6) ? 3'd0 :  // wrap-around from 6 to 0
                q + 3'd1;          // otherwise increment

// Sequential state register
always @(posedge clk) begin
    q <= next_q;
end

endmodule