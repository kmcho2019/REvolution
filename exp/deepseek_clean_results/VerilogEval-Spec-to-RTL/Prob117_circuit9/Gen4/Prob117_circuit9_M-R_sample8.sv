module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4;  // synchronous reset to 4 when a=1
    end else begin
        // increment with wrap-around from 6 to 0
        q <= (q == 3'd6) ? 3'd0 : q + 3'd1;
    end
end

endmodule