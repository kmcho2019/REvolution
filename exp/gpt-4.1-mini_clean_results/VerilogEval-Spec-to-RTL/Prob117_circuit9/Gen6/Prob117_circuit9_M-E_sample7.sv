module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4;               // Hold q at 4 when a is high
    end else begin
        if (q == 3'd6) begin
            q <= 3'd0;           // Wrap around from 6 to 0
        end else begin
            q <= q + 3'd1;       // Increment otherwise
        end
    end
end

endmodule