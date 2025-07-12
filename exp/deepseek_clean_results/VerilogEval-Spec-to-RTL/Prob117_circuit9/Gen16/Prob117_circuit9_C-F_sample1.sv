module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4;  // Force to 4 when a is high
    end else begin
        // Increment and wrap around from 0 to 6
        q <= (q == 3'd6) ? 3'd0 : q + 3'd1;
    end
end

endmodule