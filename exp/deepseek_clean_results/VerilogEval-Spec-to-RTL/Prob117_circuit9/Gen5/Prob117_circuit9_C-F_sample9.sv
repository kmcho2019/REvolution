module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

initial q = 3'd4;  // initialize to 4

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4;  // synchronous reset to 4 when a=1
    end else if (q == 3'd6) begin
        q <= 3'd0;  // wrap-around from 6 to 0
    end else begin
        q <= q + 3'd1;  // normal increment
    end
end

endmodule