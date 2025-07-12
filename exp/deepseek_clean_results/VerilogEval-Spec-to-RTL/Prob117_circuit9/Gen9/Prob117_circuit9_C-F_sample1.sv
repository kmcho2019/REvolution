module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4;  // synchronous reset to 4 when a=1
    end else if (q != 3'd4) begin  // only update counter when not holding at 4
        if (q == 3'd6) begin
            q <= 3'd0;  // wrap around from 6 to 0
        end else begin
            q <= q + 1'b1;  // increment otherwise
        end
    end
end

endmodule