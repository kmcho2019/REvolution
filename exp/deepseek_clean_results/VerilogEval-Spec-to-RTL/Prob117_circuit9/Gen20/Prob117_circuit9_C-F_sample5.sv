module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4;  // Hold at 4 when a is high
    end else begin
        // Increment with wrap-around at 6
        q <= (q == 3'd6) ? 3'd0 : q + 1'b1;
    end
end

endmodule