module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        // Force to 4 when 'a' is high
        q <= 3'd4;
    end else begin
        // Increment and wrap around from 0-6
        q <= (q == 3'd6) ? 3'd0 : q + 3'd1;
    end
end

endmodule