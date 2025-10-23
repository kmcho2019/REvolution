module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

wire [2:0] next_q;

// Calculate next_q based on input a and current q
assign next_q = a ? 3'd4 : 
                (q == 3'd3) ? 3'd4 :  // wrap from 3 back to 4
                (q == 3'd6) ? 3'd0 :  // wrap from 6 back to 0
                q + 3'd1;             // increment otherwise

always @(posedge clk) begin
    q <= next_q;
end

endmodule