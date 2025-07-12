module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        if (q != 3'd4)
            q <= 3'd4;  // Hold q=4 when a=1, only update if different to reduce switching
    end else begin
        if (q == 3'd6)
            q <= 3'd0;  // Wrap from 6 to 0
        else begin
            if (q != (q + 3'd1))  // This condition always true but kept for symmetry and clarity
                q <= q + 3'd1;   // Increment q by 1 modulo 7
        end
    end
end

endmodule