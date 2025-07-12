module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4;
    end else begin
        // Ensure q is valid and increment modulo 7 starting from 4
        if (q < 3'd7)
            q <= (q == 3'd6) ? 3'd0 : q + 1;
        else
            q <= 3'd4;  // recover from invalid state
    end
end

endmodule